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
    var startPoint: Coordinate?
    var distance: Double
    var timePosted: Date
    var clubId: String
    var runIds: [String]
    
    init(id: String? = nil, date: Date, name: String, startPoint: CLLocationCoordinate2D?, clubId: String, distance: Double, runIds: [String]) {
        self.id = id
        self.date = date
        self.name = name
        self.timePosted = Date()
        self.clubId = clubId
        self.startPoint = Coordinate(from: startPoint ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
        self.distance = distance
        self.runIds = runIds
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decode(DocumentID<String>.self, forKey: .id)
        self.date = try container.decode(Date.self, forKey: .date)
        self.name = try container.decode(String.self, forKey: .name)
        self.clubId = try container.decode(String.self, forKey: .clubId)
        self.timePosted = try container.decode(Date.self, forKey: .timePosted)
        self.startPoint = try container.decode(Coordinate.self, forKey: .startPoint)
        self.distance = try container.decode(Double.self, forKey: .distance)
        self.runIds = try container.decode([String].self, forKey: .runIds)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.timePosted, forKey: .timePosted)
        try container.encode(self.date, forKey: .date)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.clubId, forKey: .clubId)
        try container.encode(self.startPoint, forKey: .startPoint)
        try container.encode(self.distance, forKey: .distance)
        try container.encode(self.runIds, forKey: .runIds)
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
        case runIds
    }
    
    
    func getDaysString() -> String {
        let dateFormatter = DateFormatterService()
        let calendar = Calendar.current
        if dateFormatter.getDateString(date: Date()) == dateFormatter.getDateString(date: date) {
            return "Today"
        } else {
            if date > Date() {
                let components = calendar.dateComponents([.day], from: Date(), to: date)
                return "In \(components.day ?? 0) days"
            } else {
                let components = calendar.dateComponents([.day], from: date, to: Date())
                return "\(components.day ?? 0) days ago"
            }
        }
        

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

