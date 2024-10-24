//
//  LocationPicker.swift
//  RunClub
//
//  Created by Rhianna McCormack on 24/10/2024.
//

import SwiftUI
import MapKit

struct LocationPicker: View {
    var getting: String
    var eventViewModel: EventViewModel

    struct PinItem: Identifiable{
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }

    @State var region = MKCoordinateRegion(center:.init(latitude: -32.5, longitude: 115.75),latitudinalMeters: 1000, longitudinalMeters: 1000)

    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true)
    }
}


//#Preview {
//    LocationPicker()
//}
