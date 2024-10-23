//
//  UserModel.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class User: Codable, Identifiable, Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    @DocumentID var id: String?
    var firstName: String?
    var lastName: String?
    var email: String
    var friendIds: [String]?
    var clubIds: [String]?
    var phoneNumber: String
    var username: String
    var runIds: [String]?
    var pendingFriendIds: [String]?
    
    init(id: String? = nil, firstName: String, lastName: String, email: String, friendIds: [String]?, clubIds: [String]?, phoneNumber: String, username: String, runIds: [String]?, pendingFriendIds: [String]?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.friendIds = friendIds
        self.clubIds = clubIds
        self.phoneNumber = phoneNumber
        self.username = username
        self.runIds = runIds
        self.pendingFriendIds = pendingFriendIds
    }

    
    enum CodingKeys: CodingKey {
        case firstName
        case lastName
        case email
        case friendIds
        case clubIds
        case phoneNumber
        case username
        case runIds
        case pendingFriendIds
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encode(friendIds, forKey: .friendIds)
        try container.encode(clubIds, forKey: .clubIds)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(username, forKey: .username)
        try container.encode(runIds, forKey: .runIds)
        try container.encode(pendingFriendIds, forKey: .pendingFriendIds)

    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.email = try container.decode(String.self, forKey: .email)
        self.friendIds = try container.decode([String].self, forKey: .friendIds)
        self.clubIds = try container.decode([String].self, forKey: .clubIds)
        self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        self.username = try container.decode(String.self, forKey: .username)
        self.runIds = try container.decode([String].self, forKey: .runIds)
        self.pendingFriendIds = try container.decode([String].self, forKey: .pendingFriendIds)


    }
    
    static func getCurrentUserId() -> String {
        if let id = Auth.auth().currentUser?.uid {
            return id
        }
        return ""
    }
}
