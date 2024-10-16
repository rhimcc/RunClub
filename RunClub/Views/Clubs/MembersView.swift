//
//  MemberView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import SwiftUI

struct MembersView: View {
    var body: some View {
        ScrollView {
            MemberRow()
            MemberRow()
            MemberRow()
            MemberRow()
        }
    }
}

#Preview {
    MembersView()
}
