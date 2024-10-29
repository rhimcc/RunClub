//
//  UserList.swift
//  RunClub
//
//  Created by Rhianna McCormack on 29/10/2024.
//

import SwiftUI

struct UserList: View {
    @State var users: [User] = []
    @ObservedObject var friendViewModel: FriendViewModel = FriendViewModel()
    let firestore = FirestoreService()
    var body: some View {
        ScrollView {
            Text("Suggested Friends")
            ForEach(users.sorted(by: { $0.friendIds?.count ?? 0 > $1.friendIds?.count ?? 0 })) { user in
                           // Check if the user is in friendViewModel.friends
                if !friendViewModel.friends.contains(where: { $0.id == user.id }) {
                    AddFriendRow(user: user)
                }
            }
        }.onAppear {
            loadUsers()
        }
    }
    
    func loadUsers() {
        firestore.loadAllUsers() { users, error in
            DispatchQueue.main.async {
                if let users = users {
                    self.users = users.filter {$0.id != User.getCurrentUserId() }
                }
            }
        }
    }
}

#Preview {
    UserList()
}
