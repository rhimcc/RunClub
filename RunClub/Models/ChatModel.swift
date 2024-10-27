//
//  ChatModel.swift
//  RunClub
//
//  Created by Rhianna McCormack on 27/10/2024.
//

import Foundation
import FirebaseFirestore

class Chat: Identifiable, Codable {
    @DocumentID var id: String?
    var timeSent: Date
    var messageContent: String
    var posterId: String
    var clubId: String
    
    init(id: String? = nil, messageContent: String, posterId: String, clubId: String) {
        self.id = id
        self.timeSent = Date()
        self.messageContent = messageContent
        self.posterId = posterId
        self.clubId = clubId
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.timeSent, forKey: .timeSent)
        try container.encode(self.messageContent, forKey: .messageContent)
        try container.encode(self.posterId, forKey: .posterId)
        try container.encode(self.clubId, forKey: .clubId)
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decode(DocumentID<String>.self, forKey: .id)
        self.timeSent = try container.decode(Date.self, forKey: .timeSent)
        self.posterId = try container.decode(String.self, forKey: .posterId)
        self.messageContent = try container.decode(String.self, forKey: .messageContent)
        self.clubId = try container.decode(String.self, forKey: .clubId)
    }
    
    enum CodingKeys: CodingKey {
        case id
        case timeSent
        case posterId
        case messageContent
        case clubId
    }
}

