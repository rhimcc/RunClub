//
//  StatView.swift
//  RunClub
//
//  Created by Alex Fogg on 29/10/2024.
//

import SwiftUI

struct StatView: View {
    let value: String
    let title: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .foregroundColor(Color("MossGreen"))
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}
