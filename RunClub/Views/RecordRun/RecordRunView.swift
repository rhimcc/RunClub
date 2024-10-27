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
            RouteMapView(showUserLocation: true, locationManager: locationManager)
                .frame(height: UIScreen.main.bounds.height * 0.73)
                .ignoresSafeArea(edges: .top)
            RunMetricsView(locationManager: locationManager, buttonShown: true)
        }
        .onAppear {
            locationManager.requestPermission()
        }
    }
}

#Preview {
    RecordRunView()
}
