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
    var body: some View {
        VStack {
            HStack {
                Text("Your Clubs")
                    .font(.title)
                Spacer()
                NavigationLink {
                    ClubView(club: Club(name: "", ownerId: User.getCurrentUserId(), memberIds: [], eventIds: [], postIds: []), editMode: true)
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 30))
                }
            }
            
            
            ScrollView {
                ForEach(clubs) { club in
                    NavigationLink {
                        ClubView(club: club, editMode: false)
                    } label: {
                        Text("Club")
                    }
                }
            }
        }.padding(.horizontal, 10)
            .onAppear {
                loadClubs()
            }
    }
    
    func loadClubs() {
        firestore.getClubs() { clubs in
            DispatchQueue.main.async {
                self.clubs = clubs
            }
        }
    }
    
 
}


#Preview {
    ClubList()
}
