//
//  RunMetricsView.swift
//  RunClub
//
//  Created by Alex Fogg on 23/10/2024.
//

import SwiftUI
import MapKit

struct RunMetricsView: View {
    @ObservedObject var locationManager: LocationService
    
    var formattedDistance: String {
        String(format: "%.2f", locationManager.distance / 1000)
    }
    
    var formattedPace: String {
        let minutes = Int(locationManager.currentPace / 60)
        let seconds = Int(locationManager.currentPace.truncatingRemainder(dividingBy: 60))
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var formattedTime: String {
        let minutes = Int(locationManager.elapsedTime / 60)
        let seconds = Int(locationManager.elapsedTime.truncatingRemainder(dividingBy: 60))
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 40) {
                MetricView(title: "Distance", value: "\(formattedDistance) km")
                MetricView(title: "Pace", value: "\(formattedPace) /km")
                MetricView(title: "Time", value: formattedTime)
            }
            
            Button(action: {
                if locationManager.isTracking {
                    locationManager.stopTracking()
                } else {
                    locationManager.startTracking()
                }
            }) {
                Text(locationManager.isTracking ? "Stop Run" : "Start Run")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(locationManager.isTracking ? Color.red : Color.green)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
