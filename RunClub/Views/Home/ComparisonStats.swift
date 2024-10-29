//
//  ComparisonStats.swift
//  RunClub
//
//  Created by Alex Fogg on 29/10/2024.
//

import SwiftUI

struct ComparisonStats: View {
    let name: String
    let stats: (distance: Double, pace: Double, count: Int)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(name)
                .font(.headline)
                .foregroundColor(Color("MossGreen"))
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: "figure.run")
                        .foregroundColor(Color("MossGreen"))
                    Text(String(format: "%.1f km", stats.distance))
                        .font(.subheadline)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "speedometer")
                        .foregroundColor(Color("MossGreen"))
                    Text(formatPace(stats.pace))
                        .font(.subheadline)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "number")
                        .foregroundColor(Color("MossGreen"))
                    Text("\(stats.count) runs")
                        .font(.subheadline)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func formatPace(_ pace: Double) -> String {
        let minutes = Int(pace)
        let seconds = Int((pace - Double(minutes)) * 60)
        return String(format: "%d:%02d /km", minutes, seconds)
    }
}
