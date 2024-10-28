//
//  StatCard.swift
//  RunClub
//
//  Created by Alex Fogg on 29/10/2024.
//

import SwiftUI

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let unit: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .foregroundColor(Color("MossGreen"))
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(.title3, design: .rounded, weight: .semibold))
                Text(unit)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(width: 140)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("lightGreen").opacity(0.1))
        )
    }
}
