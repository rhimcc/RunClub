//
//  UserRow.swift
//  RunClub
//
//  Created by Alex Fogg on 30/10/2024.
//


import SwiftUI

struct UserRow: View {
    let user: User
    let status: FriendshipStatus
    let onAction: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            Circle()
                .fill(Color("MossGreen"))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(user.username.prefix(1).uppercased())
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .medium))
                )
            
            // User info
            VStack(alignment: .leading, spacing: 4) {
                Text(user.username)
                    .font(.system(size: 16, weight: .semibold))
                if let firstName = user.firstName, let lastName = user.lastName {
                    Text("\(firstName) \(lastName)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Action button
            switch status {
            case .friends:
                NavigationLink {
                    ChatView(friend: user)
                } label: {
                    Image(systemName: "message.fill")
                        .foregroundColor(Color("MossGreen"))
                }
            case .pending:
                Button {
                    onAction()
                } label: {
                    Text("Cancel")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            case .notFriends:
                Button {
                    onAction()
                } label: {
                    Text("Follow")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color("MossGreen"))
                        .cornerRadius(8)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}