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
   var onAction: (() -> Void)?
   var onAccept: (() -> Void)?
   let myId = User.getCurrentUserId()
   @State private var currentUserPending: [String] = []
   let firestore = FirestoreService()
   
   var body: some View {
       HStack(spacing: 12) {
           Circle()
               .fill(Color("MossGreen"))
               .frame(width: 50, height: 50)
               .overlay(
                   Text(user.username.prefix(1).uppercased())
                       .foregroundColor(.white)
                       .font(.system(size: 20, weight: .medium))
               )
           
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
           
           switch status {
           case .friends:
               NavigationLink {
                   ChatView(friend: user)
               } label: {
                   Image(systemName: "message.fill")
                       .foregroundColor(Color("MossGreen"))
               }
               
           case .pending:
               if user.pendingFriendIds?.contains(myId) ?? false {
                   // We sent them a request
                   Button {
                       onAction?()
                   } label: {
                       Text("Cancel")
                           .font(.system(size: 14, weight: .medium))
                           .foregroundColor(.gray)
                           .padding(.horizontal, 12)
                           .padding(.vertical, 6)
                           .background(Color.gray.opacity(0.2))
                           .cornerRadius(8)
                   }
               } else if currentUserPending.contains(user.id ?? "") {
                   // They sent us a request
                   HStack(spacing: 8) {
                       Button {
                           onAccept?()
                       } label: {
                           Text("Accept")
                               .font(.system(size: 14, weight: .medium))
                               .foregroundColor(.white)
                               .padding(.horizontal, 12)
                               .padding(.vertical, 6)
                               .background(Color("MossGreen"))
                               .cornerRadius(8)
                       }
                       
                       Button {
                           onAction?()
                       } label: {
                           Text("Decline")
                               .font(.system(size: 14, weight: .medium))
                               .foregroundColor(.gray)
                               .padding(.horizontal, 12)
                               .padding(.vertical, 6)
                               .background(Color.gray.opacity(0.2))
                               .cornerRadius(8)
                       }
                   }
               }
               
           case .notFriends:
               Button {
                   onAction?()
               } label: {
                   Text("Add Friend")
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
       .onAppear {
           firestore.getUserByID(id: myId) { user in
               if let user = user {
                   self.currentUserPending = user.pendingFriendIds ?? []
               }
           }
       }
   }
}
