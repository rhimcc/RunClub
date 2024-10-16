//
//  ClubFeed.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import SwiftUI

struct ClubFeed: View {
    var body: some View {
        ScrollView {
            PostView()
            PostView()
            PostView()
        }
    }
}

#Preview {
    ClubFeed()
}
