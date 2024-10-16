//
//  UserModel.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import Foundation
import FirebaseFirestore

struct User {
    @DocumentID var id: String?
    var username: String?
    var email: String
    var friends: [String]
    
    init(id: String, username: String, email: String, friends: [String]) {
        self.id = id
        self.username = username
        self.email = email
        self.friends = friends
    }
    
}
