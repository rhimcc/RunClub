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
                HStack {
                    Text("Friends")
                        .font(.title)
                    Spacer()
                    NavigationLink {
                        AddFriendView()
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 30))
                    }
                }.padding()
                if (!friendViewModel.pending.isEmpty) {
                    Text("Pending (\(friendViewModel.pending.count))")
                    ForEach(friendViewModel.pending) { pendingFriend in
                        PendingFriendRow(user: pendingFriend, friendViewModel: friendViewModel)
                    }
                }
                
                if !friendViewModel.friends.isEmpty {
                    Text("Friends (\(friendViewModel.friends.count))")
                    ForEach(friendViewModel.friends) { friend in
                        FriendRow(user: friend)
                    }
                }
            }.padding(.horizontal, 10)
        }/*.frame(maxWidth: .infinity, alignment: .leading)*/
    }
    
 
}

#Preview {
    FriendsView()
}
