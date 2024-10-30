//
//  UserSearchView.swift
//  RunClub
//
//  Created by Alex Fogg on 30/10/2024.
//

import SwiftUI

struct UserSearchView: View {
    @ObservedObject var searchViewModel: SearchViewModel
    @ObservedObject var friendViewModel: FriendViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if !searchViewModel.isSearching {
                            Text(searchViewModel.searchQuery.isEmpty ? "SUGGESTED USERS" : "SEARCH RESULTS")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                                .padding(.top, 8)
                            
                            LazyVStack(spacing: 12) {
                                ForEach(searchViewModel.searchQuery.isEmpty ? searchViewModel.suggestedUsers : searchViewModel.searchResults) { user in
                                    // Check if current user's ID is in the other user's pending requests
                                    let isPending = friendViewModel.pending.contains(user)
                                    let status = isPending ? .pending : friendViewModel.getFriendshipStatus(for: user)
                                    
                                    UserRow(
                                        user: user,
                                        status: status,
                                        onAction: {
                                            friendViewModel.handleFriendAction(for: user)
                                        }
                                    )
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
                
                if searchViewModel.isSearching {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                }
            }
            .navigationTitle("Add Friends")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchViewModel.searchQuery, prompt: "Search users")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
