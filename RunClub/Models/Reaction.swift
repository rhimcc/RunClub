//
//  Reaction.swift
//  RunClub
//
//  Created by Alex Fogg on 29/10/2024.
//

import SwiftUI

struct Reaction: Codable, Identifiable {
    
    let id: String
    let userId: String
    let type: ReactionType
    let timestamp: Date
    
    enum ReactionType: String, Codable, CaseIterable {
        case like = "like"
        case celebrate = "celebrate"
        case support = "support"
        case thumbsDown = "thumbs_down"
        case shocked = "shocked"
    }
}
