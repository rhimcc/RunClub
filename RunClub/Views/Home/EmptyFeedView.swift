//
//  EmptyFeedView.swift
//  RunClub
//
//  Created by Alex Fogg on 29/10/2024.
//

import SwiftUI
import Foundation

struct EmptyFeedView: View {
    var body: some View {
        VStack(spacing: 20) {
            Circle()
                .fill(Color("lightGreen").opacity(0.1))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "figure.run")
                        .font(.system(size: 40))
                        .foregroundColor(Color("MossGreen"))
                )
            
            Text("No Activities Yet")
                .font(.title3.bold())
                .foregroundColor(Color("MossGreen"))
            
            VStack(alignment: .leading, spacing: 12) {
                SuggestionRow(icon: "person.2.fill", text: "Follow friends to see their runs")
                SuggestionRow(icon: "person.3.fill", text: "Join clubs to see events")
                SuggestionRow(icon: "figure.run", text: "Go for a run to start tracking")
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("lightGreen").opacity(0.1))
        )
        .padding()
    }
}
