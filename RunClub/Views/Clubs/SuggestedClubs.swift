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
            
            if clubs.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(Color("MossGreen"))
                    
                    Text("You've joined all available clubs!")
                        .font(.headline)
                    
                    Text("Why not create your own club?")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 40)
            } else {
                ForEach(clubs.sorted(by: {$0.memberIds.count > $1.memberIds.count})) { club in
                    NavigationLink {
                        ClubView(club: club, editMode: false)
                    } label: {
                        ClubRow(club: club)
                    }
                }
            }
        }
        .onAppear {
            loadClubs()
        }
    }
    
    func loadClubs() {
        firestore.loadAllClubs() { clubs, error in
            DispatchQueue.main.async {
                if let clubs = clubs {
                    self.clubs = clubs.filter {
                        !$0.memberIds.contains(User.getCurrentUserId()) && 
                        $0.ownerId != User.getCurrentUserId()
                    }
                }
            }
        }
    }
}
