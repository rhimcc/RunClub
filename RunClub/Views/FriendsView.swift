//
//  FriendsView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 23/10/2024.
//

import SwiftUI

struct FriendsView: View {
    @ObservedObject var friendViewModel: FriendViewModel = FriendViewModel()
    @State private var showingAddFriends = false
    let firestore = FirestoreService()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Add Friend Button
                Button {
                    showingAddFriends = true
                } label: {
                    HStack {
                        Text("Add Friend")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "plus.circle.fill")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("MossGreen"))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // Pending Friends Section
                if !friendViewModel.pending.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Friend Requests (\(friendViewModel.pending.count))")
                            .font(.headline)
                            .foregroundColor(Color("MossGreen"))
                            .padding(.horizontal)
                        
                        ForEach(friendViewModel.pending) { user in
                            UserRow(
                                user: user,
                                status: .pending,
                                onAction: {
                                    // Handle reject/cancel
                                    firestore.rejectFriendRequest(from: user.id ?? "") {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            friendViewModel.loadFriends()
                                        }
                                    }
                                },
                                onAccept: {
                                    firestore.acceptFriendRequest(from: user.id ?? "")
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        friendViewModel.loadFriends()
                                    }
                                }
                            )
                            .padding(.horizontal)
                        }
                    }
                }
                
                // Friends Section
                if !friendViewModel.friends.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Friends (\(friendViewModel.friends.count))")
                            .font(.headline)
                            .foregroundColor(Color("MossGreen"))
                            .padding(.horizontal)
                        
                        ForEach(friendViewModel.friends) { friend in
                            NavigationLink {
                                ProfileView(authViewModel: AuthViewModel(), user: friend)
                            } label: {
                                UserRow(
                                    user: friend,
                                    status: .friends,
                                    onAction: {
                                        friendViewModel.handleFriendAction(for: friend)
                                    }
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal)
                        }
                    }
                }
                
                // Empty State
                if friendViewModel.friends.isEmpty && friendViewModel.pending.isEmpty {
                    VStack(spacing: 12) {
                        Text("No Friends Yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Start adding friends to connect with other runners!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 40)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Friends")
        .sheet(isPresented: $showingAddFriends) {
            UserSearchView(
                searchViewModel: SearchViewModel(),
                friendViewModel: friendViewModel
            )
        }
        .onAppear {
            friendViewModel.loadFriends()
        }
    }
}

