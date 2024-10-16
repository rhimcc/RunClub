//
//  EventModel.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import Foundation
import FirebaseFirestore
import CoreLocation

struct Event {
    @DocumentID var id: String?
    var date: Date
    var name: String
    var location: CLLocationCoordinate2D
    var postedDate: Date
}
