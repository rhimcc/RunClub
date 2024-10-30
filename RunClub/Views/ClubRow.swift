//
//  ClubRow.swift
//  RunClub
//
//  Created by Rhianna McCormack on 24/10/2024.
//

import SwiftUI

struct ClubRow: View {
    let club: Club
    let firestore = FirestoreService()
    @State var member: Bool
    
    init(club: Club) {
        self.club = club
        self._member = State(initialValue: club.memberIds.contains(User.getCurrentUserId()))
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Club Avatar
            Circle()
                .fill(Color("MossGreen"))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(club.name.prefix(1).uppercased())
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .medium))
                )
            
            // Club info
            VStack(alignment: .leading, spacing: 4) {
                Text(club.name)
                    .font(.system(size: 16, weight: .semibold))
                HStack(spacing: 4) {
                    Image(systemName: "person.2")
                        .foregroundColor(.gray)
                    Text("\(club.memberIds.count) members")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Join/Leave Button
            if club.ownerId != User.getCurrentUserId() {
                Button {
                    if let id = club.id {
                        if member {
                            firestore.leaveClub(clubId: id)
                            member = false
                        } else {
                            firestore.joinClub(clubId: id)
                            member = true
                        }
                    }
                } label: {
                    Text(member ? "Leave" : "Join")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .medium))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(member ? Color.red : Color("MossGreen"))
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

//#Preview {
//    ClubRow()
//}
