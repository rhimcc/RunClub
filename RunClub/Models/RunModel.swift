//
//  RunModel.swift
//  RunClub
//
//  Created by Alex Fogg on 23/10/2024.
//

import Foundation
import FirebaseFirestore
import CoreLocation

class Run: Identifiable, Codable {
    @DocumentID var id: String?
    var eventId: String?
    var locations: [CLLocation]
    var startTime: Date?
    var elapsedTime: TimeInterval
    
    init(id: String? = nil, eventId: String? = nil, locations: [CLLocation], startTime: Date?, elapsedTime: TimeInterval) {
        self.id = id
        self.eventId = eventId
        self.locations = locations
        self.startTime = startTime
        self.elapsedTime = elapsedTime
    }
    
    private struct LocationData: Codable {
        let latitude: Double
        let longitude: Double
        let timestamp: Date
        let altitude: Double
        
        init(from location: CLLocation) {
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
            self.timestamp = location.timestamp
            self.altitude = location.altitude
        }
        
        func toCLLocation() -> CLLocation {
            return CLLocation(
                coordinate: CLLocationCoordinate2D(
                    latitude: latitude,
                    longitude: longitude
                ),
                altitude: altitude,
                horizontalAccuracy: 0,
                verticalAccuracy: 0,
                timestamp: timestamp
            )
        }
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(eventId, forKey: .eventId)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(elapsedTime, forKey: .elapsedTime)
        
        let locationData = locations.map { LocationData(from: $0) }
        try container.encode(locationData, forKey: .locations)
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decode(DocumentID<String>.self, forKey: .id)
        self.eventId = try container.decodeIfPresent(String.self, forKey: .eventId)
        self.startTime = try container.decode(Date.self, forKey: .startTime)
        self.elapsedTime = try container.decode(TimeInterval.self, forKey: .elapsedTime)
        let locationData = try container.decode([LocationData].self, forKey: .locations)
        self.locations = locationData.map { $0.toCLLocation() }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case eventId
        case locations
        case startTime
        case elapsedTime
    }
}
