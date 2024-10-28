//
//  HomeView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 15/10/2024.
//

import SwiftUI

struct HomeView: View {
    @State var friends: [User] = []
    @ObservedObject var authViewModel: AuthViewModel
    @State var runs: [Run] = []
    let firestore = FirestoreService()
    @State var isLoading: Bool = false
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    Text("Run Club")
                        .font(.title)
                    Spacer()

                }.padding()
                ForEach(runs) { run in
                    RunRow(run: run, onProfile: false)
                }
            }
        }.onAppear {
            loadFriends() {
                loadRuns()
            }
        }.padding()
        
    }
    func loadFriends(completion: @escaping () -> Void) {
        firestore.getFriendsOfUser(userId: User.getCurrentUserId()) { friends, error in
            DispatchQueue.main.async {
                if let friends = friends {
                    self.friends = friends
                    completion()
                }
            }
        }
    }
    
    func loadRuns() {
        runs = []
        for friend in friends {
            if let runIds = friend.runIds {
                for runId in runIds {
                    firestore.getRunById(id: runId) { run in
                        DispatchQueue.main.async {
                            if let run = run {
                                runs.append(run)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView(authViewModel: AuthViewModel())
}
