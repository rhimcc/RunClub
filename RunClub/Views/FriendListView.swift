//
//  FriendListView.swift
//  RunClub
//
//  Created by Alex Fogg on 30/10/2024.
//

import SwiftUI

struct FriendListView: View {
    @ObservedObject var friendViewModel: FriendViewModel
    @StateObject var searchViewModel = SearchViewModel()
    @State private var showingSearch = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if !friendViewModel.pending.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Pending Requests")
                            .font(.headline)
                            .foregroundColor(Color("MossGreen"))
                            .padding(.horizontal)
                        
                        ForEach(friendViewModel.pending) { user in
                            FriendRow(
                                user: user,
                                status: .pending,
                                onAction: {
                                    friendViewModel.handleFriendAction(for: user)
                                },
                                showMessage: false
                            )
                            .padding(.horizontal)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Friends")
                        .font(.headline)
                        .foregroundColor(Color("MossGreen"))
                        .padding(.horizontal)
                    
                    ForEach(friendViewModel.friends) { friend in
                        FriendRow(
                            user: friend,
                            status: .friends,
                            showMessage: true
                        )
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Friends")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingSearch = true
                } label: {
                    Image(systemName: "person.badge.plus")
                        .foregroundColor(Color("MossGreen"))
                }
            }
        }
        .sheet(isPresented: $showingSearch) {
            UserSearchView(searchViewModel: searchViewModel, friendViewModel: friendViewModel)
        }
    }
}
