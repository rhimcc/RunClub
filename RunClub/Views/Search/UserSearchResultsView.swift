//
//  UserSearchResultsView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 23/10/2024.
//

import SwiftUI

struct UserSearchResultsView: View {
    @ObservedObject var searchViewModel: SearchViewModel
    @ObservedObject var friendViewModel = FriendViewModel()
    @State private var error: Error?
    
    var body: some View {
        VStack(spacing: 0) {
            if searchViewModel.searchQuery.isEmpty {
                // Show suggested users when no search
                VStack(alignment: .leading, spacing: 16) {
                    Text("SUGGESTED USERS")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    if searchViewModel.isSearching {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else if searchViewModel.searchResults.isEmpty {
                        Text("No users found")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(searchViewModel.searchResults) { user in
                                    UserRow(
                                        user: user,
                                        status: friendViewModel.getFriendshipStatus(for: user),
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
            } else {
                // Show search results
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if searchViewModel.isSearching {
                            ProgressView()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        } else if searchViewModel.searchResults.isEmpty {
                            Text("No users found")
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        } else {
                            ForEach(searchViewModel.searchResults) { user in
                                FriendRow(
                                    user: user,
                                    status: friendViewModel.getFriendshipStatus(for: user),
                                    onAction: {
                                        friendViewModel.handleFriendAction(for: user)
                                    },
                                    showMessage: false
                                )
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
        }
        .padding(.top, 20)
        .onChange(of: searchViewModel.searchQuery) { newValue in
            if !newValue.isEmpty {
                searchViewModel.searchUsers(searchText: newValue)
            }
        }
    }
}

