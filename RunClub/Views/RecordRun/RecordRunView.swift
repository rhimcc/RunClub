//
//  RecordRunView.swift
//  RunClub
//
//  Created by Alex Fogg on 23/10/2024.
//

import SwiftUI

struct RecordRunView: View {
    @StateObject private var locationManager = LocationService()
    var body: some View {
        VStack {
            RouteMapView(locationManager: locationManager)
                .frame(height: UIScreen.main.bounds.height * 0.7)
            RunMetricsView(locationManager: locationManager)
        }
        .onAppear {
            locationManager.requestPermission()
        }
    }
}

#Preview {
    RecordRunView()
}
