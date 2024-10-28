//
//  ClubList.swift
//  RunClub
//
//  Created by Rhianna McCormack on 15/10/2024.
//

import SwiftUI

struct ClubList: View {
    let firestore = FirestoreService()
    @State var clubs: [Club] = []
    @State var usersClubs: [Club] = []
    @State var ownedClubs: [Club] = []
    @ObservedObject var clubViewModel: ClubViewModel = ClubViewModel()

    var body: some View {
        VStack (alignment: .leading){
            HStack {
                Text("Your Clubs")
                    .font(.title)
                Spacer()
                NavigationLink {
                    // Search clubs
                } label: {
                    ZStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.mossGreen)
                            .font(.system(size: 25))
                    }
                }
                
                NavigationLink {
                    ClubView(club: Club(name: "", ownerId: User.getCurrentUserId(), memberIds: [], eventIds: [], messageIds: []), editMode: true)
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 30))
                }
            }.padding()
            
            
            ScrollView {
                VStack (alignment: .leading){
                    if (ownedClubs.count > 0) {
                        Text("Owned (\(ownedClubs.count))")
                            .padding(.horizontal, 10)
                        ForEach(ownedClubs) { club in
                            NavigationLink {
                                ClubView(club: club, editMode: false)
                            } label: {
                                ClubRow(club: club)
                                    .padding(.horizontal, 10)
                            }
                        }
                    }
                    if (usersClubs.count > 0) {
                        Text("Participant (\(usersClubs.count))")
                            .padding(.horizontal, 10)
                        ForEach(usersClubs) { club in
                            NavigationLink {
                                ClubView(club: club, editMode: false)
                            } label: {
                                Text("Club")
                            }
                        }
                    }
                    if (usersClubs.count == 0 && ownedClubs.count == 0) {
                        Text("You are not in any clubs, join or create one!")
                            .foregroundStyle(.gray)
                    }
                }
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
            .onAppear {
                loadClubsOfUser()
                loadClubsUserOwns()
                loadClubs()
            }
    }
    
    func loadClubs() {
        firestore.loadAllClubs() { clubs, error in
            DispatchQueue.main.async {
                if let clubs = clubs {
                    self.clubs = clubs
                }
            }
        }
    }
    
    func loadClubsOfUser() {
        firestore.getUsersClubs(userId: User.getCurrentUserId()) { clubs, error in
            DispatchQueue.main.async {
                if let clubs = clubs {
                    self.usersClubs = clubs
                }
            }
        }
    }
    
    func loadClubsUserOwns() {
        firestore.getClubsUserOwns(userId: User.getCurrentUserId()) { clubs, error in
            DispatchQueue.main.async {
                if let clubs = clubs {
                    self.ownedClubs = clubs
                }
            }
        }
    }
    
 
}


#Preview {
    ClubList()
}
