//
//  RunActivityAttributes.swift
//  RunClub
//
//  Created by Rhianna McCormack on 30/10/2024.
//

import ActivityKit
import Foundation

struct RunActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var distance: Double
        var pace: TimeInterval
        var elapsedTime: TimeInterval
    }
    
    var runName: String
}

// Example extension for formatting if needed
extension RunActivityAttributes.ContentState {
    var formattedDistance: String {
        String(format: "%.2f km", distance / 1000)
    }
    
    var formattedPace: String {
        let minutes = Int(pace / 60)
        let seconds = Int(pace.truncatingRemainder(dividingBy: 60))
        return String(format: "%d:%02d /km", minutes, seconds)
    }
    
    var formattedElapsedTime: String {
        let hours = Int(elapsedTime / 3600)
        let minutes = Int((elapsedTime.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(elapsedTime.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
