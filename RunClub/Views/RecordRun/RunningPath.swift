//
//  RunningPath.swift
//  RunClub
//
//  Created by Alex Fogg on 23/10/2024.
//

import SwiftUI
import CoreLocation

struct RunningPath: View {
    let locations: [CLLocation]
    
    var body: some View {
        GeometryReader { geometry in
            let coordinates = locations.map { $0.coordinate }
            Path { path in
                guard !coordinates.isEmpty else { return }
                
                var cgPoints: [CGPoint] = []
                for coordinate in coordinates {
                    let point = geometry.coordinateToPoint(coordinate)
                    cgPoints.append(point)
                }
                
                if let firstPoint = cgPoints.first {
                    path.move(to: firstPoint)
                    for point in cgPoints.dropFirst() {
                        path.addLine(to: point)
                    }
                }
            }
            .stroke(Color.blue, lineWidth: 3)
        }
    }
}
