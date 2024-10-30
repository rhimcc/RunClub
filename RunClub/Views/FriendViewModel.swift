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
        
        firestore.getFriendsOfUser(userId: userId) { [weak self] friends, error in
            DispatchQueue.main.async {
                if let friends = friends {
                    self?.friends = friends
                }
            }
        }
        
        firestore.getPendingFriendsOfUser(userId: userId) { [weak self] pending, error in
            DispatchQueue.main.async {
                if let pending = pending {
                    self?.pending = pending
                }
            }
        }
    }
    
    func getFriendshipStatus(for user: User) -> FriendshipStatus {
        // Check if user ID exists in friends array
        if friends.contains(user) {
            return .friends
        }
        // Check if user ID exists in pending array
        else if pending.contains(user) {
            return .pending
        }
        // If neither, they're not a friend
        return .notFriends
    }
    
    func handleFriendAction(for user: User) {
        switch getFriendshipStatus(for: user) {
            case .friends:
                if let userId = user.id {
                    firestore.unfriend(userId: User.getCurrentUserId(), friendId: userId) {
                        DispatchQueue.main.async {
                            self.friends.removeAll { $0.id == userId }
                        }
                    }
                }
            case .pending:
                if let userId = user.id {
                    // Update UI state immediately
                    DispatchQueue.main.async {
                        self.pending.removeAll { $0.id == userId }
                    }
                    // Then handle the backend
                    firestore.cancelFriendRequest(to: userId) {
                        // No need to update UI here since we did it above
                    }
                }
            case .notFriends:
                if let userId = user.id {
                    // Update UI state immediately
                    DispatchQueue.main.async {
                        self.pending.append(user)
                    }
                    // Then handle the backend
                    firestore.sendFriendRequest(to: user)
                }
        }
    }
}
