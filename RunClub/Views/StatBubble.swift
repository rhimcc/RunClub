//
//  StatBubble.swift
//  RunClub
//
//  Created by Alex Fogg on 29/10/2024.
//

import SwiftUI

struct StatBubble: View {
    let icon: String
    let value: String
    let unit: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(Color("MossGreen"))
            Text(value + unit)
                .font(.system(size: 14, weight: .medium))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(Color("MossGreen").opacity(0.1))
        )
    }
}
