//
//  SearchViewModel.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.

import Foundation

class SearchViewModel: ObservableObject {
    let firestore = FirestoreService()
    @Published var searchQuery = ""
    @Published var searchResults: [User] = []
    @Published var isSearching = false
    @Published var suggestedUsers: [User] = []
    
    init() {
        loadSuggestedUsers()
    }
    
    func searchUsers(searchText: String) {
        guard !searchText.isEmpty else {
            searchResults = []
            return
        }
        
        isSearching = true
        firestore.searchUsers(searchTerm: searchText) { [weak self] users, error in
            DispatchQueue.main.async {
                self?.isSearching = false
                if let users = users {
                    self?.searchResults = users
                }
            }
        }
    }
    
    func loadSuggestedUsers() {
        isSearching = true
        firestore.getMostFollowedUsers { [weak self] users, error in
            DispatchQueue.main.async {
                self?.isSearching = false
                if let users = users {
                    self?.suggestedUsers = users
                }
            }
        }
    }
}
