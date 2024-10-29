//
//  PersonalView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 15/10/2024.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State var user: User?
    @State private var runs: [Run] = []
    @State private var friendshipStatus: FriendshipStatus = .notFriends
    let firestore = FirestoreService()
    
    private var isCurrentUser: Bool {
        user?.id == User.getCurrentUserId()
    }
    
    var body: some View {
       ScrollView {
            VStack(spacing: 0) {
                HStack{
                    Spacer()
                    if isCurrentUser {
                        Button(action: {
                            authViewModel.signOut()
                        }) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundStyle(.red)
                                .opacity(0.6)
                                .font(.system(size: 20))
                        }
                        .padding(.horizontal, 10)
                    }
                }
                VStack(spacing: 12) {
                    HStack(spacing: 20) {
                        Circle()
                            .fill(Color("MossGreen"))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Text((user?.username.prefix(1) ?? "A").uppercased())
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            )
                        
                        Spacer()
                        
                        HStack(spacing: 40) {
                            VStack(spacing: 4) {
                                Text("\(user?.runIds?.count ?? 0)")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Runs")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }
                            
                            VStack(spacing: 4) {
                                Text("\(user?.friendIds?.count ?? 0)")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Friends")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }
                            
                            VStack(spacing: 4) {
                                Text("\(user?.clubIds?.count ?? 0)")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Clubs")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }
                        }
                        Spacer()
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 1) {
                        Text(user?.username ?? "")
                            .font(.system(size: 22, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if !isCurrentUser {
                        Button(action: handleFriendshipAction) {
                            Text(friendshipButtonText)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(friendshipButtonColor)
                                .cornerRadius(12)
                        }
                        .padding(.top, 12)
                    }
                }
                .padding()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        StatCard(
                            icon: "flame.fill",
                            title: "Total Distance",
                            value: String(format: "%.1f", calculateTotalDistance()),
                            unit: "km"
                        )
                        
                        StatCard(
                            icon: "clock.fill",
                            title: "Total Time",
                            value: formatTotalTime(),
                            unit: ""
                        )
                        
                        StatCard(
                            icon: "speedometer",
                            title: "Avg Pace",
                            value: String(format: "%.1f", calculateAveragePace()),
                            unit: "/km"
                        )
                        
                        StatCard(
                            icon: "arrow.up.right",
                            title: "Total Elevation",
                            value: String(format: "%.0f", calculateTotalElevation()),
                            unit: "m"
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                if !runs.isEmpty {
                    HStack {
                        Text("Recent Runs")
                            .font(.headline)
                            .foregroundColor(Color("MossGreen"))
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    LazyVStack(spacing: 16) {
                        ForEach(runs) { run in
                            RunRow(run: run, onProfile: true)
                        }
                    }
                    .padding(.top, 8)
                }
            }
        }
        .onAppear {
            if user == nil {
                getCurrentUser {
                    loadRuns()
                    checkFriendshipStatus()
                }
            } else {
                loadRuns()
                checkFriendshipStatus()
            }
            MapSnapshotPrefetcher.shared.prefetchSnapshots(for: runs)
        }
    }
    
    private func checkFriendshipStatus() {
        guard authViewModel.isSignedIn else { return }
        guard !isCurrentUser, let otherUserId = user?.id else { return }
        let userId = User.getCurrentUserId()
        
        firestore.checkFriendshipStatus(userId: userId, otherUserId: otherUserId) { status in
            DispatchQueue.main.async {
                self.friendshipStatus = status
            }
        }
    }
    
    private func getCurrentUser(completion: @escaping () -> Void) {
        guard authViewModel.isSignedIn else { return }
        firestore.getUserByID(id: User.getCurrentUserId()) { user in
            DispatchQueue.main.async {
                if let user = user {
                    self.user = user
                    completion()
                }
            }
        }
    }
    
    private func loadRuns() {
        guard authViewModel.isSignedIn else { return }
        if let user = user, let id = user.id {
            firestore.getRunsOfUser(userId: id) { runs, error in
                DispatchQueue.main.async {
                    if let runs = runs {
                        self.runs = runs.sorted(by: { $0.startTime > $1.startTime })
                    }
                }
            }
        }
    }
    
    private var friendshipButtonText: String {
        switch friendshipStatus {
        case .friends:
            return "Unfriend"
        case .pending:
            return "Request Pending"
        case .notFriends:
            return "Add Friend"
        }
    }
    
    private var friendshipButtonColor: Color {
        switch friendshipStatus {
        case .friends:
            return Color("MossGreen")
        case .pending:
            return Color.gray
        case .notFriends:
            return Color("MossGreen")
        }
    }
    
    private func handleFriendshipAction() {
        let userId = User.getCurrentUserId()
         guard let otherUserId = user?.id else { return }
        
        switch friendshipStatus {
        case .friends:
            firestore.unfriend(userId: userId, friendId: otherUserId) {
                friendshipStatus = .notFriends
            }
        case .notFriends:
            firestore.sendFriendRequest(to: user!)
            friendshipStatus = .pending
        case .pending:
            break
        }
    }
    
    private func calculateTotalDistance() -> Double {
        runs.reduce(0.0) { total, run in
            let distance = run.locations.enumerated().dropLast().reduce(0.0) { sum, element in
                sum + element.element.distance(from: run.locations[element.offset + 1])
            }
            return total + (distance / 1000)
        }
    }
    
    private func calculateAveragePace() -> Double {
        let totalDistance = calculateTotalDistance()
        let totalTime = runs.reduce(0.0) { $0 + $1.elapsedTime }
        guard totalDistance > 0 else { return 0 }
        return (totalTime / 60) / totalDistance
    }
    
    private func formatTotalTime() -> String {
        let totalSeconds = runs.reduce(0.0) { $0 + $1.elapsedTime }
        let hours = Int(totalSeconds / 3600)
        let minutes = Int((totalSeconds.truncatingRemainder(dividingBy: 3600)) / 60)
        return "\(hours)h \(minutes)m"
    }
    
    private func calculateTotalElevation() -> Double {
        runs.reduce(0.0) { total, run in
            let elevation = run.locations.enumerated().dropLast().reduce(0.0) { sum, element in
                let heightDiff = run.locations[element.offset + 1].altitude - element.element.altitude
                return sum + (heightDiff > 0 ? heightDiff : 0)
            }
            return total + elevation
        }
    }
    
    private func getMostActiveDay() -> String {
        let calendar = Calendar.current
        let runCounts = runs.reduce(into: [Int: Int]()) { counts, run in
            let weekday = calendar.component(.weekday, from: run.startTime)
            counts[weekday, default: 0] += 1
        }
        
        if let mostActive = runCounts.max(by: { $0.value < $1.value }) {
            return calendar.weekdaySymbols[mostActive.key - 1]
        }
        return "N/A"
    }
    
    
}
