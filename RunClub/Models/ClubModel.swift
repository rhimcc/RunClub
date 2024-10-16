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
    var ownerId: String
    var memberIds: [String]
    var eventIds: [String]
    var postIds: [String]
}
