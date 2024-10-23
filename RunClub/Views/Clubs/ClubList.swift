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

    var body: some View {
        VStack {
            HStack {
                Text("Your Clubs")
                    .font(.title)
                Spacer()
                NavigationLink {
                    AddClubView()
                } label: {
                    ZStack {
                        Circle()
                            .fill(.lightGreen)
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.white)
                            .bold()
                        
                    }
                }
                NavigationLink {
                    ClubView(club: Club(name: "", ownerId: User.getCurrentUserId(), memberIds: [], eventIds: [], postIds: []), editMode: true)
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 30))
                }
            }
            
            
            ScrollView {
                ForEach(usersClubs) { club in
                    NavigationLink {
                        ClubView(club: club, editMode: false)
                    } label: {
                        Text("Club")
                    }
                }
            }
        }.padding(.horizontal, 10)
            .onAppear {
                loadClubsOfUser()
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
    
 
}


#Preview {
    ClubList()
}
