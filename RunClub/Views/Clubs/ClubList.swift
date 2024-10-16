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
            Text("Your Clubs")
                .font(.title)
            NavigationLink {
                ClubView()
            } label: {
                Text("Club")
            }
        }
    }
}

#Preview {
    ClubList()
}
