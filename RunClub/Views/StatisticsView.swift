//
//  StatisticsView.swift
//  RunClub
//
//  Created by Alex Fogg on 29/10/2024.
//

import SwiftUI

struct StatisticsView: View {
    let runs: [Run]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Total Distance: \(calculateTotalDistance(), specifier: "%.1f") km")
            Text("Total Time: \(formatTotalTime())")
            Text("Average Pace: \(calculateAveragePace(), specifier: "%.2f") min/km")
        }
    }
    
    private func calculateTotalDistance() -> Double {
        runs.reduce(0.0) { total, run in
            let distance = run.locations.enumerated().dropLast().reduce(0.0) { sum, element in
                sum + element.element.distance(from: run.locations[element.offset + 1])
            }
            return total + (distance / 1000)
        }
    }
    
    private func calculateAveragePace() -> Double {
        let totalDistance = calculateTotalDistance()
        let totalTime = runs.reduce(0.0) { $0 + $1.elapsedTime }
        guard totalDistance > 0 else { return 0 }
        return (totalTime / 60) / totalDistance
    }
    
    private func formatTotalTime() -> String {
        let totalSeconds = runs.reduce(0.0) { $0 + $1.elapsedTime }
        let hours = Int(totalSeconds / 3600)
        let minutes = Int((totalSeconds.truncatingRemainder(dividingBy: 3600)) / 60)
        return "\(hours)h \(minutes)m"
    }
}
