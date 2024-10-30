//
//  SearchResultsView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import SwiftUI

struct SearchResultsView: View {
    @ObservedObject var searchViewModel: SearchViewModel
    @State var clubs: [Club] = []
    let firestore = FirestoreService()
    
    var body: some View {
        ScrollView {
            ForEach(clubs.filter {$0.name.contains(searchViewModel.searchQuery)}) { club in
                NavigationLink {
                    ClubView(club: club, editMode: false)
                } label: {
                    ClubRow(
                        club: club
                        )
                    }
                }
        }
        .padding(.top, 20)
        .onAppear {
            loadUsers()
        }
    }
    func loadUsers() {
        firestore.loadAllClubs() { clubs, error in
            DispatchQueue.main.async {
                if let clubs = clubs {
                    self.clubs = clubs
                }
            }
        }
    }
}

//#Preview {
//    SearchResultsView(searchViewModel: SearchViewModel())
//}
