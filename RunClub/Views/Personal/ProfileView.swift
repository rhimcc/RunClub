//
//  PersonalView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 15/10/2024.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State var user: User? = nil
    let firestore = FirestoreService()
    @State var runs: [Run] = []
    var body: some View {
        ScrollView {
            
            HStack {
                Spacer()
                Circle()
                    .fill(.mossGreen)
                    .frame(width: 120)
                if let user = user, let firstName = user.firstName, let lastName = user.lastName {
                    Text(firstName + " " + lastName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title)
                }
                Spacer()
                if let user = user, let id = user.id {
                    if (id == User.getCurrentUserId()) {
                        VStack {
                            NavigationLink {
                                SettingsView(authViewModel: authViewModel)
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(.lightGreen)
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: "gearshape")
                                        .foregroundStyle(.white)
                                        .bold()
                                    
                                }.padding(.trailing, 10)
                            }
                            Spacer()
                        }
                    }
                }
            }
            HStack {
                Spacer()
                VStack {
                    Text("Friends")
                        .bold()
                    if let user = user, let friendIds = user.friendIds {
                        Text("\(String(describing: friendIds.count))")
                        
                    }
                }
                Spacer()
                VStack {
                    Text("Clubs") // includes both the ones user owns and is a member of
                        .bold()
                    if let user = user, let clubIds = user.clubIds {
                        Text("\(String(describing: clubIds.count))")
                    }
                }
                Spacer()
            }.padding()
            
        
            
            Line()
            if let user = user, let id = user.id {
                if (id == User.getCurrentUserId()) {
                    Text("Your recent runs")
                } else {
                    if let firstName = user.firstName {
                        Text("\(firstName)'s recent runs")
                    }
                }
            }
            ScrollView {
                ForEach(runs) { run in
                    RunRow(run: run, onProfile: true)
                }
            }

        }.onAppear {
            if (user == nil) {
                getCurrentUser() {
                    loadRuns()
                }
            } else {
                loadRuns()
            }
        }
    }
    private func getCurrentUser(completion: @escaping () -> Void) {
        firestore.getUserByID(id: User.getCurrentUserId()) { user in
            DispatchQueue.main.async {
                if let user = user {
                    self.user = user
                }
            }
        }
    }
    
    func loadRuns() {
        if let user = user, let id = user.id {
            firestore.getRunsOfUser(userId: id) { runs, error in
                DispatchQueue.main.async {
                    if let runs = runs {
                        self.runs = runs
                        print(runs.count)
                    }
                }
            }
        }
    }
    
    
    
    
}



#Preview {
    ProfileView(authViewModel: AuthViewModel(), user: User(id: "123", firstName: "12rtgr", lastName: "rgrefd", email: "wfwgew", friendIds: [], clubIds: [], phoneNumber: "92034829", username: "fwheufijfnr", runIds: [], pendingFriendIds: []))
}
