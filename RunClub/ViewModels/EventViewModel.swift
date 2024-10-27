//
//  EventViewModel.swift
//  RunClub
//
//  Created by Rhianna McCormack on 25/10/2024.
//

import Foundation
import MapKit

class EventViewModel: ObservableObject {
    var name: String = ""
    var startPoint: CLLocationCoordinate2D? = nil
    var distance: Double = 0
    var date: Date? = nil
}
