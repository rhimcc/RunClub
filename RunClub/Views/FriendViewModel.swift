//
//  FriendViewModel.swift
//  RunClub
//
//  Created by Rhianna McCormack on 23/10/2024.
//

import Foundation
import FirebaseAuth
class FriendViewModel: ObservableObject {
    let firestore = FirestoreService()
    @Published var pending: [User] = []
    @Published var friends: [User] = []
    init() {
        loadFriends()
    }
    
    func loadFriends() {
        guard let userId = Auth.auth().currentUser?.uid else { 
            self.friends = []
            self.pending = []
            return 
        }
        
        firestore.getFriendsOfUser(userId: userId) { friends, error in
            DispatchQueue.main.async {
                if let friends = friends {
                    self.friends = friends
                }
            }
        }
        
        firestore.getPendingFriendsOfUser(userId: userId) { pending, error in
            DispatchQueue.main.async {
                if let pending = pending {
                    self.pending = pending
                }
            }
        }
    }
    
}
