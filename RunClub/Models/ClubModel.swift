//
//  ClubModel.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import Foundation
import FirebaseFirestore

struct Club {
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
}
