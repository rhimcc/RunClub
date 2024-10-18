//
//  ClubList.swift
//  RunClub
//
//  Created by Rhianna McCormack on 15/10/2024.
//

import SwiftUI

struct ClubList: View {
    var body: some View {
        VStack {
            HStack {
                Text("Your Clubs")
                    .font(.title)
                Spacer()
                NavigationLink {
                    ClubOwnerView(club: Club(name: "", ownerId: User.getCurrentUserId(), memberIds: [], eventIds: [], postIds: []), editMode: true)
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 30))
                }
            }
            
            
            ScrollView {
                NavigationLink {
                    ClubView(club: Club(name: "Club name", ownerId: "123", memberIds: [], eventIds: [], postIds: []))
                } label: {
                    Text("Club")
                }
            }
        }.padding(.horizontal, 10)
    }
}


#Preview {
    ClubList()
}
