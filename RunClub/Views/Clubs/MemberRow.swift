//
//  MemberRow.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import SwiftUI

struct MemberRow: View {
    var body: some View {
        HStack {
            Circle()
                .frame(width: 40)
            
            Text("Member Name")
                .font(.title)
            Spacer()
            Text("Member since: date")
                .font(.headline)
        }.padding(.vertical, 20)
            .padding(.horizontal, 10)
            .background(RoundedRectangle(cornerRadius: 20).stroke(.gray, lineWidth: 3))
    }
}

#Preview {
    MemberRow()
}
