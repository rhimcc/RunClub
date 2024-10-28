//
//  ClubFeedView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 27/10/2024.
//

import SwiftUI

struct ClubFeedView: View {
    let firestore = FirestoreService()
    var club: Club
    
    var body: some View {
        ScrollView {
            ForEach()
        }.onAppear {
            loadClubFeed()
        }
    }
    
    func loadClubFeed() {
//        firestore.loadClubFeed(clubId: club.id)
    }
    
}
