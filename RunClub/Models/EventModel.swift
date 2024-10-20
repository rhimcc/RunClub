//
//  EventModel.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import Foundation
import FirebaseFirestore
import CoreLocation

struct Event: Codable {
    @DocumentID var id: String?
    var date: Date
    var name: String
    var location: CLLocationCoordinate2D?
    var timePosted: Date
    var clubId: String
    
    init(id: String? = nil, date: Date, name: String, location: CLLocationCoordinate2D, timePosted: Date, clubId: String) {
        self.id = id
        self.date = date
        self.name = name
        self.location = location
        self.timePosted = timePosted
        self.clubId = clubId
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decode(DocumentID<String>.self, forKey: .id)
        self.date = try container.decode(Date.self, forKey: .date)
        self.name = try container.decode(String.self, forKey: .name)
        self.timePosted = try container.decode(Date.self, forKey: .timePosted)
//        self.location = try container.decode(String.self, forKey: .messageContent)
        self.clubId = try container.decode(String.self, forKey: .clubId)
        self.location = nil
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.timePosted, forKey: .timePosted)
        try container.encode(self.date, forKey: .date)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.clubId, forKey: .clubId)
    }
    
    enum CodingKeys: CodingKey {
        case id
        case date
        case name
        case location
        case timePosted
        case clubId
    }
}
