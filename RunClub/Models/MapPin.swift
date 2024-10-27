//
//  MapPin.swift
//  RunClub
//
//  Created by Alex Fogg on 27/10/2024.
//

import Foundation
import CoreLocation


struct MapPin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
