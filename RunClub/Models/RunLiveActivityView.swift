//
//  RunLiveActivityView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 30/10/2024.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct RunActivityView: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: RunActivityAttributes.self) { context in
            HStack(spacing: 20) {
                VStack {
                    Text("Distance")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(String(format: "%.2f km", context.state.distance / 1000))
                        .font(.title2)
                        .bold()
                }
                
                VStack {
                    Text("Pace")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(formatPace(context.state.pace))
                        .font(.title2)
                        .bold()
                }
                
                VStack {
                    Text("Time")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(formatTime(context.state.elapsedTime))
                        .font(.title2)
                        .bold()
                }
            }
            .padding()
            .activityBackgroundTint(Color.black.opacity(0.8))
            .activitySystemActionForegroundColor(Color.white)
            
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text(String(format: "%.2f km", context.state.distance / 1000))
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.white)
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Text(formatPace(context.state.pace))
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.white)

                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    Text(formatTime(context.state.elapsedTime))
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.white)

                }
            } compactLeading: {
                Text(String(format: "%.1f", context.state.distance / 1000))
                    .font(.caption2)
                    .foregroundStyle(.white)

            } compactTrailing: {
                Text(formatTime(context.state.elapsedTime))
                    .font(.caption2)
                    .foregroundStyle(.white)

            } minimal: {
                Text(String(format: "%.1f", context.state.distance / 1000))
                    .font(.caption2)
                    .foregroundStyle(.white)
                
//                Image("AppIcon")
            }
        }
    }
    
    private func formatPace(_ pace: TimeInterval) -> String {
        let minutes = Int(pace / 60)
        let seconds = Int(pace.truncatingRemainder(dividingBy: 60))
        return String(format: "%d:%02d/km", minutes, seconds)
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time / 60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        return String(format: "%d:%02d", minutes, seconds)
    }
}

