//
//  ClubModel.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import Foundation
import FirebaseFirestore

struct Club: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var ownerId: String
    var memberIds: [String]
    var eventIds: [String]
    var postIds: [String]
    
    init(id: String? = nil, name: String, ownerId: String, memberIds: [String], eventIds: [String], postIds: [String]) {
        self.id = id
        self.name = name
        self.ownerId = ownerId
        self.memberIds = memberIds
        self.eventIds = eventIds
        self.postIds = postIds
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.ownerId, forKey: .ownerId)
        try container.encode(self.memberIds, forKey: .memberIds)
        try container.encode(self.eventIds, forKey: .eventIds)
        try container.encode(self.postIds, forKey: .postIds)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decode(DocumentID<String>.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.ownerId = try container.decode(String.self, forKey: .ownerId)
        self.memberIds = try container.decode([String].self, forKey: .memberIds)
        self.eventIds = try container.decode([String].self, forKey: .eventIds)
        self.postIds = try container.decode([String].self, forKey: .postIds)

    }
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case ownerId
        case memberIds
        case eventIds
        case postIds
    }
}
