//
//  RunClubWidgetExtensionLiveActivity.swift
//  RunClubWidgetExtension
//
//  Created by Alex Fogg on 30/10/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct RunClubWidgetExtensionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct RunClubWidgetExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: RunActivityAttributes.self) { context in
            RunLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text(String(format: "%.2f km", context.state.distance / 1000))
                        .font(.title2)
                        .bold()
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(formatPace(context.state.pace))
                        .font(.title2)
                        .bold()
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(formatTime(context.state.elapsedTime))
                        .font(.title2)
                        .bold()
                }
            } compactLeading: {
                Text(String(format: "%.1f", context.state.distance / 1000) + "km")
                    .font(.caption2)
                    .foregroundStyle(.white)
            } compactTrailing: {
                Text(formatTime(context.state.elapsedTime))
                    .font(.caption2)
                    .foregroundStyle(.white)
            } minimal: {
                Text(String(format: "%.1f", context.state.distance / 1000) + "km")
                    .font(.caption2)
                    .foregroundStyle(.white)
            }
        }
    }
    func formatTime(_ elapsedTime: TimeInterval) -> String {
        let time = Int(elapsedTime)
        let hours = time / 3600
        let minutes = (time % 3600) / 60
        let seconds = time % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else if minutes > 0 {
            return String(format: "%d:%02d", minutes, seconds)
        } else {
            return String(format: "%d s", seconds)
        }
    }
    private func formatPace(_ pace: TimeInterval) -> String {
        let minutes = Int(pace / 60)
        let seconds = Int(pace.truncatingRemainder(dividingBy: 60))
        return String(format: "%d:%02d/km", minutes, seconds)
    }
}

extension RunClubWidgetExtensionAttributes {
    fileprivate static var preview: RunClubWidgetExtensionAttributes {
        RunClubWidgetExtensionAttributes(name: "World")
    }
}

extension RunClubWidgetExtensionAttributes.ContentState {
    fileprivate static var smiley: RunClubWidgetExtensionAttributes.ContentState {
        RunClubWidgetExtensionAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: RunClubWidgetExtensionAttributes.ContentState {
         RunClubWidgetExtensionAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: RunClubWidgetExtensionAttributes.preview) {
   RunClubWidgetExtensionLiveActivity()
} contentStates: {
    RunClubWidgetExtensionAttributes.ContentState.smiley
    RunClubWidgetExtensionAttributes.ContentState.starEyes
}

struct RunLiveActivityView : View {
    
    let context: ActivityViewContext<RunActivityAttributes>
        
    var body: some View {
        VStack {
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
            
            // Display Elapsed Time
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
    }
        
    private func formatPace(_ pace: TimeInterval) -> String {
        let minutes = Int(pace / 60)
        let seconds = Int(pace.truncatingRemainder(dividingBy: 60))
        return String(format: "%d:%02d/km", minutes, seconds)
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time / 3600)
        let minutes = Int((time.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
