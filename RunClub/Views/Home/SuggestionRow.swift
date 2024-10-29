//
//  SuggestionRow.swift
//  RunClub
//
//  Created by Alex Fogg on 29/10/2024.
//

import SwiftUI

struct SuggestionRow: View {
    let icon: String
    let text: String
    
    init(icon: String, text: String) {
        self.icon = icon
        self.text = text
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Color("MossGreen"))
                .font(.system(size: 16))
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
}
