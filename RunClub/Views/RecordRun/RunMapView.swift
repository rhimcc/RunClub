//
//  RunMapView.swift
//  RunClub
//
//  Created by Alex Fogg on 23/10/2024.
//

import MapKit
import SwiftUI

struct RunMapView: View {
    @ObservedObject var locationManager: LocationService
    
    var body: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(
            center: locationManager.locations.last?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )), showsUserLocation: true)
    }
}
