//
//  TabButton.swift
//  RunClub
//
//  Created by Alex Fogg on 29/10/2024.
//

import SwiftUI

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .foregroundColor(isSelected ? Color("MossGreen") : .gray)
                Rectangle()
                    .fill(isSelected ? Color("MossGreen") : .clear)
                    .frame(height: 2)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
