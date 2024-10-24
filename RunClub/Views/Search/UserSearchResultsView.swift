//
//  UserSearchResultsView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 23/10/2024.
//

import SwiftUI

struct UserSearchResultsView: View {
    @ObservedObject var searchViewModel: SearchViewModel
    let firestore = FirestoreService()
    @State var users: [User] = []
    @State var error: Error?
    var body: some View {
        ScrollView {
            ForEach(users.filter {$0.username.contains(searchViewModel.searchQuery) && $0.id != User.getCurrentUserId()}) { user in
                AddFriendRow(user: user)
            }
        }.padding(.top, 20)
        .onAppear {
            loadUsers()
        }
    }
    func loadUsers() {
        firestore.loadAllUsers() { users, error in
            DispatchQueue.main.async {
                if let users = users {
                    self.users = users
                    self.error = error
                }
            }
        }
    }
}

#Preview {
    UserSearchResultsView(searchViewModel: SearchViewModel())
}
