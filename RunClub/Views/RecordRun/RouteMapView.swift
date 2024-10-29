//
//  RouteMapView.swift
//  RunClub
//
//  Created by Alex Fogg on 23/10/2024.
//

import SwiftUI
import MapKit
import CoreLocation

struct RouteMapView: View {
    var showUserLocation: Bool
    @ObservedObject var locationManager: LocationService
    
    var body: some View {
        MapViewRepresentable(showUserLocation: showUserLocation, locationManager: locationManager)
            .edgesIgnoringSafeArea(.top)
    }
}
