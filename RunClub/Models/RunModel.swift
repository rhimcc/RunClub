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
    var startTime: Date
    var elapsedTime: TimeInterval
    var runnerId: String
    
    init(id: String? = nil, eventId: String? = nil, locations: [CLLocation], startTime: Date, elapsedTime: TimeInterval, runnerId: String) {
        self.id = id
        self.eventId = eventId
        self.locations = locations
        self.startTime = startTime
        self.elapsedTime = elapsedTime
        self.runnerId = runnerId
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
        try container.encode(runnerId, forKey: .runnerId)
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decode(DocumentID<String>.self, forKey: .id)
        self.eventId = try container.decodeIfPresent(String.self, forKey: .eventId)
        self.startTime = try container.decode(Date.self, forKey: .startTime)
        self.elapsedTime = try container.decode(TimeInterval.self, forKey: .elapsedTime)
        let locationData = try container.decode([LocationData].self, forKey: .locations)
        self.locations = locationData.map { $0.toCLLocation() }
        self.runnerId = try container.decode(String.self, forKey: .runnerId)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case eventId
        case locations
        case startTime
        case elapsedTime
        case runnerId
    }
    
    func calculateDistance() -> Double {
        var distance = 0.0
        guard locations.count > 1 else { return distance }
        
        for i in 0..<locations.count-1 {
            distance += locations[i].distance(from: locations[i+1])
        }
        return distance / 1000
    }
    
    func calculatePace() -> Double {
        let distance = calculateDistance()
        guard distance > 0 else { return 0 }
        return (elapsedTime / 60) / distance
    }
    
    func getFormattedPace() -> String {
        let pace = calculatePace()
        let minutes = Int(pace)
        let seconds = Int((pace - Double(minutes)) * 60)
        return String(format: "%d:%02d /km", minutes, seconds)
    }
    
    func getFormattedTime() -> String {
        let hours = Int(elapsedTime) / 3600
        let minutes = Int(elapsedTime) / 60 % 60
        let seconds = Int(elapsedTime) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
}
