//
//  ClubRow.swift
//  RunClub
//
//  Created by Rhianna McCormack on 24/10/2024.
//

import SwiftUI

struct ClubRow: View {
    var club: Club
    @State var member: Bool = false
    let firestore = FirestoreService()
    var body: some View {
        HStack {
            Circle()
                .fill(.gray)
                .frame(width: 60, height: 60)
            VStack (alignment: .leading){
                Text(club.name)
                    .bold()
                Text(member ? "Member" : "Not a Member")
                
            }.foregroundStyle(.black)
            Spacer()
        }.onAppear {
            getMemberStatus()
        }
        .padding()
        .background (
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: .black.opacity(0.2), radius: 5)
        ).padding()

    }
    
    func getMemberStatus() {
        member = club.memberIds.contains(User.getCurrentUserId())
            
    }
}

//#Preview {
//    ClubRow()
//}
