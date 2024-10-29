//
//  WeeklyStatsCard.swift
//  RunClub
//
//  Created by Alex Fogg on 29/10/2024.
//

import SwiftUI

struct WeeklyStatsCard: View {
   let user: User
    let runs: [Run]
    
    private var totalDistance: Double {
        runs.reduce(0.0) { sum, run in
            sum + run.calculateDistance()
        }
    }
    
    private var bestPace: Double {
        runs.min(by: { $0.calculatePace() < $1.calculatePace() })?.calculatePace() ?? 0
    }
    
    private var longestRun: Run? {
        runs.max(by: { $0.calculateDistance() < $1.calculateDistance() })
    }
    
    private var totalTime: TimeInterval {
        runs.reduce(0) { $0 + $1.elapsedTime }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Main stats
            HStack(spacing: 24) {
                StatBubble(
                    icon: "figure.run",
                    value: String(format: "%.1f", totalDistance),
                    unit: "km"
                )
                
                if let longest = longestRun {
                    StatBubble(
                        icon: "trophy",
                        value: String(format: "%.1f", longest.calculateDistance()),
                        unit: "km best"
                    )
                }
                
                StatBubble(
                    icon: "clock",
                    value: formatDuration(totalTime),
                    unit: "total"
                )
            }
            
            // Achievements section
            if runs.count > 0 {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(getAchievements(), id: \.self) { achievement in
                        HStack(spacing: 6) {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color("MossGreen"))
                            Text(achievement)
                                .font(.subheadline)
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("lightGreen").opacity(0.1))
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
//        .padding(.horizontal)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        return hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"
    }
    
    private func getAchievements() -> [String] {
        var achievements: [String] = []
        
        if let longest = longestRun {
            achievements.append("Longest run: \(String(format: "%.1f", longest.calculateDistance()))km")
        }
        
        if let fastestRun = runs.min(by: { $0.calculatePace() < $1.calculatePace() }) {
            achievements.append("Best pace: \(fastestRun.getFormattedPace())")
        }
        
        if runs.count > 1 {
            achievements.append("Completed \(runs.count) runs this week!")
        }
        
        if totalDistance >= 10 {
            achievements.append("Covered over \(String(format: "%.0f", totalDistance))km this week!")
        }
        
        return achievements
    }
}
