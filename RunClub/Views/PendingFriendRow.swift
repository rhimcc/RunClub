//
//  PendingFriendRow.swift
//  RunClub
//
//  Created by Rhianna McCormack on 23/10/2024.
//

import SwiftUI

struct PendingFriendRow: View {
    let firestore = FirestoreService()
    var user: User
    var friendViewModel: FriendViewModel
    var body: some View {
        HStack {
            Circle()
                .fill(.mossGreen)
            if let firstName = user.firstName, let lastName = user.lastName {
                Text(firstName + " " + lastName)
            }
            Button {
                acceptFriend()
              
            } label: {
                Image(systemName: "checkmark.circle")
            }
            Button {
                // reject friend request
            } label: {
                Image(systemName: "x.circle")
            }
            
        }.frame(height: 200)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.2), radius: 5)
            }.padding()
    }
    
    func acceptFriend() {
            if let id = user.id {
                firestore.acceptFriendRequest(from: id)
                
                firestore.getUserByID(id: id) { fetchedUser in
                    DispatchQueue.main.async {
                        if let fetchedUser = fetchedUser {
                            // Update the friendViewModel after fetching the user
                            if let index = friendViewModel.pending.firstIndex(where: {$0.id == id}) {
                                friendViewModel.pending.remove(at: index)
                            }
                            friendViewModel.friends.append(fetchedUser)
                        }
                    }
                }
            }
        }
}

//#Preview {
//    PendingFriendRow(user: )
//}
