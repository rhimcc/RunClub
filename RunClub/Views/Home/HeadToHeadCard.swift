//
//  HeadToHeadCard.swift
//  RunClub
//
//  Created by Alex Fogg on 29/10/2024.
//

import SwiftUI

struct HeadToHeadCard: View {
    let user1: User
    let user2: User
    let runs1: [Run]
    let runs2: [Run]
    
    private var stats1: (distance: Double, pace: Double, count: Int) {
        getStats(for: runs1)
    }
    
    private var stats2: (distance: Double, pace: Double, count: Int) {
        getStats(for: runs2)
    }
    
    private var winner: (user: User, metric: String)? {
        let score1 = calculateScore(distance: stats1.distance, count: stats1.count)
        let score2 = calculateScore(distance: stats2.distance, count: stats2.count)
        
        if score1 > 0 && score2 == 0 {
            return (user1, "is in the lead!")
        } else if score2 > 0 && score1 == 0 {
            return (user2, "is in the lead!")
        }
        
        if score1 > score2 {
            let percentage = calculatePercentage(higher: score1, lower: score2)
            return (user1, "\(percentage)% ahead")
        } else if score2 > score1 {
            let percentage = calculatePercentage(higher: score2, lower: score1)
            return (user2, "\(percentage)% ahead")
        }
        
        return nil
    }
    
    private func calculateScore(distance: Double, count: Int) -> Double {
        guard !distance.isNaN && !distance.isInfinite else { return 0 }
        return distance * max(Double(count), 1)
    }
    
    private func calculatePercentage(higher: Double, lower: Double) -> Int {
        guard higher > 0 else { return 0 }
        if lower == 0 { return 100 }
        let percentage = ((higher / lower) - 1) * 100
        guard !percentage.isNaN && !percentage.isInfinite else { return 0 }
        return max(0, min(999, Int(percentage)))
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(user1.username)
                    .font(.headline)
                    .foregroundColor(Color("MossGreen"))
                Text("VS")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text(user2.username)
                    .font(.headline)
                    .foregroundColor(Color("MossGreen"))
            }
            
            HStack(spacing: 20) {
                ComparisonStats(
                    name: user1.username,
                    stats: stats1
                )
                
                Rectangle()
                    .fill(Color("MossGreen"))
                    .frame(width: 1)
                    .padding(.vertical, 8)
                
                ComparisonStats(
                    name: user2.username,
                    stats: stats2
                )
            }
            
            if let winner = winner {
                HStack {
                    Image(systemName: "trophy.fill")
                        .foregroundColor(Color("MossGreen"))
                    Text("\(winner.user.username) \(winner.metric)")
                        .font(.headline)
                        .foregroundColor(Color("MossGreen"))
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("lightGreen").opacity(0.1))
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
    
    private func getStats(for runs: [Run]) -> (distance: Double, pace: Double, count: Int) {
        guard !runs.isEmpty else { return (0, 0, 0) }
        
        let validRuns = runs.filter { 
            let distance = $0.calculateDistance()
            let pace = $0.calculatePace()
            return !distance.isNaN && !distance.isInfinite && 
                   !pace.isNaN && !pace.isInfinite &&
                   distance > 0
        }
        
        guard !validRuns.isEmpty else { return (0, 0, 0) }
        
        let distance = validRuns.reduce(0.0) { sum, run in
            let dist = run.calculateDistance()
            return sum + (dist.isNaN || dist.isInfinite ? 0 : dist)
        }
        
        let totalPace = validRuns.reduce(0.0) { sum, run in
            let pace = run.calculatePace()
            return sum + (pace.isNaN || pace.isInfinite ? 0 : pace)
        }
        
        let avgPace = totalPace / Double(validRuns.count)
        
        return (distance, avgPace, validRuns.count)
    }
}

