//
//  PostModel.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import Foundation
import FirebaseFirestore

class Message: Identifiable, Codable {
    @DocumentID var id: String?
    var timePosted: Date
    var messageContent: String
    var posterId: String
    var clubId: String
    
    init(id: String? = nil, messageContent: String, posterId: String, clubId: String) {
        self.id = id
        self.timePosted = Date()
        self.messageContent = messageContent
        self.posterId = posterId
        self.clubId = clubId
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.timePosted, forKey: .timePosted)
        try container.encode(self.messageContent, forKey: .messageContent)
        try container.encode(self.posterId, forKey: .posterId)
        try container.encode(self.clubId, forKey: .clubId)
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decode(DocumentID<String>.self, forKey: .id)
        self.timePosted = try container.decode(Date.self, forKey: .timePosted)
        self.posterId = try container.decode(String.self, forKey: .posterId)
        self.messageContent = try container.decode(String.self, forKey: .messageContent)
        self.clubId = try container.decode(String.self, forKey: .clubId)
    }
    
    enum CodingKeys: CodingKey {
        case id
        case timePosted
        case posterId
        case messageContent
        case clubId
    }
    
    func getTimeString() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short      // E.g., 5:30 PM
        formatter.timeZone = .current     // Adjusts to the user's time zone
        return formatter.string(from: timePosted)
    }
    func getDateString() -> String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMMd") // set template after setting locale
        return (formatter.string(from: timePosted)) // December 31
    }
        
}

