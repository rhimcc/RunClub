//
//  UserModel.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class User: Codable {
    @DocumentID var id: String?
    var firstName: String?
    var lastName: String?
    var email: String
    var friendIds: [String]?
    
    init(id: String? = nil, firstName: String, lastName: String, email: String, friendIds: [String]?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.friendIds = friendIds
    }
    
    enum CodingKeys: CodingKey {
        case firstName
        case lastName
        case email
        case friendIds
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encode(friendIds, forKey: .friendIds)
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.email = try container.decode(String.self, forKey: .email)
        self.friendIds = try container.decode([String].self, forKey: .friendIds)
    }
    
    static func getCurrentUserId() -> String {
        if let id = Auth.auth().currentUser?.uid {
            return id
        }
        return ""
    }
}
