//
//  AddFriendRow.swift
//  RunClub
//
//  Created by Rhianna McCormack on 23/10/2024.
//

import SwiftUI

struct AddFriendRow: View {
    let firestore = FirestoreService()
    var user: User
    var body: some View {
        HStack {
            Circle()
                .fill(.mossGreen)
            if let firstName = user.firstName, let lastName = user.lastName {
                Text(firstName + " " + lastName)
            }
            Button("Add friend") {
                firestore.sendFriendRequest(to: user)
            }
        }.frame(height: 200)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.2), radius: 5)
            }.padding()
    }
}

//#Preview {
//    AddFriendRow()
//}
