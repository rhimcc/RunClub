//
//  FriendsView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 23/10/2024.
//

import SwiftUI

struct FriendsView: View {
    @ObservedObject var friendViewModel: FriendViewModel = FriendViewModel()
    let firestore = FirestoreService()
    var body: some View {
        ScrollView {
            VStack (alignment: .leading){
                Text("Friends")
                    .font(.title)
                NavigationLink {
                    AddFriendView()
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
                    .cornerRadius(8)
                }
                  
                if (!friendViewModel.pending.isEmpty) {
                    Text("Pending (\(friendViewModel.pending.count))")
                    ForEach(friendViewModel.pending) { pendingFriend in
                        PendingFriendRow(user: pendingFriend, friendViewModel: friendViewModel)
                    }
                }
                
                if !friendViewModel.friends.isEmpty {
                    Text("Friends (\(friendViewModel.friends.count))")
                    ForEach(friendViewModel.friends) { friend in
                        NavigationLink {
                            ProfileView(authViewModel: AuthViewModel(), user: friend)
                        } label: {
                            FriendRow(user: friend, friends: true)
                        }
                    }
                }
            }.padding(.horizontal, 10)
        }/*.frame(maxWidth: .infinity, alignment: .leading)*/
    }
    
 
}

#Preview {
    FriendsView()
}
