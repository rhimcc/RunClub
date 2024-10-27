//
//  Coordinate.swift
//  RunClub
//
//  Created by Alex Fogg on 27/10/2024.
//

import CoreLocation

struct Coordinate: Codable, Hashable {
    var latitude: Double
    var longitude: Double
    
    init(from location: CLLocationCoordinate2D) {
        self.latitude = location.latitude
        self.longitude = location.longitude
    }
    
    func toCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
