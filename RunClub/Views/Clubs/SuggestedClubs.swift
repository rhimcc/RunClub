//
//  SuggestedClubs.swift
//  RunClub
//
//  Created by Rhianna McCormack on 29/10/2024.
//

import SwiftUI

struct SuggestedClubs: View {
    let firestore = FirestoreService()
    @State var clubs: [Club] = [] // will be the clubs the user is not in
    var body: some View {
        ScrollView {
            Text("Suggested Clubs")
            ForEach(clubs.sorted(by: {$0.memberIds.count > $1.memberIds.count})) { club in
                NavigationLink {
                    ClubView(club: club, editMode: false)
                } label : {
                    ClubRow(
                        club: club
                    )
                }
            }
        }.onAppear {
            loadClubs()
        }
        
        
    }
    
    func loadClubs() {
        firestore.loadAllClubs() { clubs, error in
            DispatchQueue.main.async {
                if let clubs = clubs {
                    self.clubs = clubs.filter {!$0.memberIds.contains(User.getCurrentUserId()) && $0.ownerId != User.getCurrentUserId()}
                }
            }
        }
    }
}

#Preview {
    SuggestedClubs()
}
