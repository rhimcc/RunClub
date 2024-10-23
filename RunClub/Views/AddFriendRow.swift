//
//  AddFriendRow.swift
//  RunClub
//
//  Created by Rhianna McCormack on 23/10/2024.
//

import SwiftUI

struct AddFriendRow: View {
    let firestore = FirestoreService()
    @ObservedObject var friendViewModel: FriendViewModel = FriendViewModel()
    var user: User
    var body: some View {
        HStack {
            Circle()
                .fill(.mossGreen)
                .frame(height: 60)
            if let firstName = user.firstName, let lastName = user.lastName {
                Text(firstName + " " + lastName)
            }
            Spacer()
            if (friendViewModel.friends.contains(user)) {
                Text("Friends")
            } else if (friendViewModel.pending.contains(user)) {
                Text("Pending")
            } else {
                Button("Add friend") {
                    firestore.sendFriendRequest(to: user)
                }
            }
        }.padding()
            .background (
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.2), radius: 5)
            ).padding(10)
    }
}

//#Preview {
//    AddFriendRow()
//}
