//
//  FriendViewModel.swift
//  RunClub
//
//  Created by Rhianna McCormack on 23/10/2024.
//

import Foundation
class FriendViewModel: ObservableObject {
    let firestore = FirestoreService()
    @Published var pending: [User] = []
    @Published var friends: [User] = []
    init() {
        loadFriends()
    }
    
    func loadFriends() {
        firestore.getFriendsOfUser(userId: User.getCurrentUserId()) { friends, error  in
            DispatchQueue.main.async {
                if let friends = friends {
                    self.friends = friends
                }
            }
        }
        firestore.getPendingFriendsOfUser(userId: User.getCurrentUserId()) { pending, error in
            DispatchQueue.main.async {
                if let pending = pending {
                    self.pending = pending
                }
            }
        }
    }
    
}
