//
//  LocationPicker.swift
//  RunClub
//
//  Created by Rhianna McCormack on 24/10/2024.
//

import SwiftUI
import MapKit

struct LocationPicker: View {
    let locationManager: LocationService = LocationService()
    var getting: String
    var eventViewModel: EventViewModel
    
    var body: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(
            center: locationManager.locations.last?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )), showsUserLocation: true)
       
    }
}



//#Preview {
//    LocationPicker()
//}
