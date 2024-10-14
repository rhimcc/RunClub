//
//  Item.swift
//  RunClub
//
//  Created by Rhianna McCormack on 14/10/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
