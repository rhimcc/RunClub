//
//  EventModel.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import Foundation
import FirebaseFirestore
import CoreLocation

struct Event: Codable, Identifiable, Hashable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
    
    @DocumentID var id: String?
    var date: Date
    var name: String
    var startPoint: Coordinate
    var distance: Double
    var timePosted: Date
    var clubId: String
    
    init(id: String? = nil, date: Date, name: String, startPoint: CLLocationCoordinate2D, clubId: String, distance: Double) {
        self.id = id
        self.date = date
        self.name = name
        self.timePosted = Date()
        self.clubId = clubId
        self.startPoint = Coordinate(from: startPoint)
        self.distance = distance
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decode(DocumentID<String>.self, forKey: .id)
        let dateUnixTime = try container.decode(Double.self, forKey: .date)
        self.date = Date(timeIntervalSince1970: dateUnixTime)
        self.name = try container.decode(String.self, forKey: .name)
        let timePostedUnix = try container.decode(Double.self, forKey: .date)
        self.timePosted = Date(timeIntervalSince1970: dateUnixTime)
        self.clubId = try container.decode(String.self, forKey: .clubId)
        self.startPoint = try container.decode(Coordinate.self, forKey: .startPoint)
        self.distance = try container.decode(Double.self, forKey: .distance)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.timePosted, forKey: .timePosted)
        try container.encode(self.date, forKey: .date)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.clubId, forKey: .clubId)
        try container.encode(startPoint, forKey: .startPoint)
        try container.encode(distance, forKey: .distance)
    }
    
    enum CodingKeys: CodingKey {
        case id
        case date
        case name
        case location
        case timePosted
        case clubId
        case startPoint
        case endPoint
        case distance
    }
    
    func getDaysUntilEvent() -> Int {
        let currentDate = Date()
        print(currentDate)
            
            // Calculate the time interval in seconds until the event date
            let timeInterval = currentDate.timeIntervalSince(date)
            print(timeInterval)
            
            // Convert seconds to days
            let daysUntilEvent = Int(timeInterval / (24 * 60 * 60)) // 24 hours * 60 minutes * 60 seconds
            print(daysUntilEvent)

            // Return the number of days until the event
            return max(0, daysUntilEvent) // Ensure we return 0 if the event has already passed
    }
    
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
}

