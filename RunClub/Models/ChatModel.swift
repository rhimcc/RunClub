//
//  ChatModel.swift
//  RunClub
//
//  Created by Rhianna McCormack on 28/10/2024.
//

import Foundation
import FirebaseFirestore

class Chat: Identifiable, Codable, Equatable {
    static func == (lhs: Chat, rhs: Chat) -> Bool {
       return lhs.id == rhs.id
    }
    
    @DocumentID var id: String?
    var timeSent: Date
    var messageContent: String
    var senderId: String
    var receiverId: String
    
    init(id: String? = nil, messageContent: String, senderId: String, receiverId: String) {
        self.id = id
        self.timeSent = Date()
        self.messageContent = messageContent
        self.senderId = senderId
        self.receiverId = receiverId
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.timeSent, forKey: .timeSent)
        try container.encode(self.messageContent, forKey: .messageContent)
        try container.encode(self.senderId, forKey: .senderId)
        try container.encode(self.receiverId, forKey: .receiverId)
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decode(DocumentID<String>.self, forKey: .id)
        self.timeSent = try container.decode(Date.self, forKey: .timeSent)
        self.senderId = try container.decode(String.self, forKey: .senderId)
        self.messageContent = try container.decode(String.self, forKey: .messageContent)
        self.receiverId = try container.decode(String.self, forKey: .receiverId)
    }
    
    enum CodingKeys: CodingKey {
        case id
        case timeSent
        case senderId
        case messageContent
        case receiverId
    }
    
    func getTimeString() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short      // E.g., 5:30 PM
        formatter.timeZone = .current     // Adjusts to the user's time zone
        return formatter.string(from: timeSent)
    }
    func getDateString() -> String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMMd") // set template after setting locale
        return (formatter.string(from: timeSent)) // December 31
    }
        
}


