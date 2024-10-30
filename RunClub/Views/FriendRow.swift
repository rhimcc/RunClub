//
//  FriendRow.swift
//  RunClub
//
//  Created by Rhianna McCormack on 23/10/2024.
//

import SwiftUI

struct FriendRow: View {
    let user: User
    var status: FriendshipStatus
    var onAction: (() -> Void)?
    let showMessage: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // User Avatar
            Circle()
                .fill(Color("MossGreen"))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(user.username.prefix(1).uppercased())
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .medium))
                )
            
            // User Info
            VStack(alignment: .leading, spacing: 4) {
                Text(user.username)
                    .font(.system(size: 16, weight: .semibold))

            }
            
            Spacer()
            
            Group {
                switch status {
                case .friends:
                    if showMessage {
                        NavigationLink {
                            ChatView(friend: user)
                        } label: {
                            Image(systemName: "message.fill")
                                .foregroundColor(Color("MossGreen"))
                        }
                    } else {
                        Button {
                            onAction?()
                        } label: {
                            Text("Unfollow")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                case .pending:
                    HStack(spacing: 8) {
                        Button {
                            onAction?()
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color("MossGreen"))
                                .font(.system(size: 24))
                        }
                        Button {
                            // Handle reject
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .foregroundColor(.red.opacity(0.8))
                                .font(.system(size: 24))
                        }
                    }
                case .notFriends:
                    Button {
                        onAction?()
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
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}
