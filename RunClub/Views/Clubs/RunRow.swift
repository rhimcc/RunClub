//
//  RunRow.swift
//  RunClub
//
//  Created by Rhianna McCormack on 28/10/2024.
//

import SwiftUI

struct RunRow: View {
    let run: Run
    let dateFormatter = DateFormatterService()
    var onProfile: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(dateFormatter.getDateString(date: run.startTime))
                        .font(.headline)
                        .foregroundColor(Color("MossGreen"))
                    
                    Text(dateFormatter.getTimeFromSeconds(seconds: Float(run.elapsedTime)))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 16) {
                    StatBubble(
                        icon: "speedometer",
                        value: String(format: "%.1f", calculatePace(distance: calculateDistance(), time: run.elapsedTime)),
                        unit: "/km"
                    )
                    
                    StatBubble(
                        icon: "figure.run",
                        value: String(format: "%.1f", calculateDistance()),
                        unit: "km"
                    )
                }
            }
            
            StaticMapView(locations: run.locations)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("lightGreen").opacity(0.1))
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
    
    private func calculateDistance() -> Double {
        var distance = 0.0
        guard run.locations.count > 1 else { return distance }
        
        for i in 0..<run.locations.count-1 {
            distance += run.locations[i].distance(from: run.locations[i+1])
        }
        return distance / 1000
    }
    
    private func calculatePace(distance: Double, time: TimeInterval) -> Double {
        guard distance > 0 else { return 0 }
        return (time / 60) / distance
    }
}

//#Preview {
//    RunRow()
//}
