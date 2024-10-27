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
    @State var navigateToSummary: Bool = false
    @State var isPresentingConfirm: Bool = false
    var buttonShown: Bool
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 20) {
                MetricBox(title: "Distance", value: formattedDistance, unit: "km")
                MetricBox(title: "Pace", value: formattedPace, unit: "/km")
                MetricBox(title: "Time", value: formattedTime, unit: "")
            }
            .padding(.horizontal)
            if (buttonShown) {
                Button(action: {
                    if locationManager.isTracking {
                        isPresentingConfirm = true
                    } else {
                        locationManager.startTracking()
                    }
                }) {
                    Text(locationManager.isTracking ? "Stop Run" : "Start Run")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 200)
                        .padding(.vertical, 12)
                        .background(locationManager.isTracking ? Color.red : Color.mossGreen)
                        .cornerRadius(25)
                }
                .padding(.bottom, 30)
                .background(
                    NavigationLink(destination: RunSummaryView(locationManager: locationManager, run: Run(locations: locationManager.locations, startTime: nil, elapsedTime: locationManager.elapsedTime)), isActive: $navigateToSummary) {
                        EmptyView()
                    }
                ).alert(isPresented: $isPresentingConfirm) {
                    Alert(
                        title: Text("Stop Run"),
                        message: Text("Are you sure you want to stop the run?"),
                        primaryButton: .destructive(Text("Stop")) {
                            locationManager.stopTracking()
                            navigateToSummary = true
                        },
                        secondaryButton: .cancel()
                    )
                    
                }
            }
            
        }
        .background(Color(UIColor.systemBackground))
        .frame(maxWidth: .infinity)
    }
}
