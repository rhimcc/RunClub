//
//  File.swift
//  RunClub
//
//  Created by Alex Fogg on 23/10/2024.
//


extension GeometryProxy {
    func coordinateToPoint(_ coordinate: CLLocationCoordinate2D) -> CGPoint {
        let rect = self.frame(in: .local)
        
        let latitudinalRange = -85.0 ... 85.0
        let longitudinalRange = -180.0 ... 180.0
        
        let x = (coordinate.longitude - longitudinalRange.lowerBound) / (longitudinalRange.upperBound - longitudinalRange.lowerBound) * rect.width
        let y = (1 - (coordinate.latitude - latitudinalRange.lowerBound) / (latitudinalRange.upperBound - latitudinalRange.lowerBound)) * rect.height
        
        return CGPoint(x: x, y: y)
    }
}