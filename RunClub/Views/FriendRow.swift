//
//  FriendRow.swift
//  RunClub
//
//  Created by Rhianna McCormack on 23/10/2024.
//

import SwiftUI

struct FriendRow: View {
    var user: User
    var body: some View {
        HStack {
            Circle()
                .fill(.gray)
                .frame(width: 60, height: 60)
            VStack {
                Text(user.firstName ?? "" + " " + (user.lastName ?? ""))
                    .bold()
                Text(user.username)
            }.foregroundStyle(.black)
            Spacer()
            NavigationLink {
                ChatView(friend: user)
            } label: {
                Image(systemName: "message")
                    .font(.system(size: 20))
                    .bold()
                    .padding(.trailing)
            }
        }.padding()
        .background (
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: .black.opacity(0.2), radius: 5)
        )

    }
}

//#Preview {
//    FriendRow()
//}
