//
//  MapViewRepresentable.swift
//  RunClub
//
//  Created by Alex Fogg on 29/10/2024.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    var showUserLocation: Bool
    @ObservedObject var locationManager: LocationService
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = showUserLocation
        
        // Only set initial tracking mode
        if showUserLocation {
            mapView.userTrackingMode = .follow
        }
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Update route overlay
        mapView.removeOverlays(mapView.overlays)
        
        if locationManager.locations.count > 1 {
            let coordinates = locationManager.locations.map { $0.coordinate }
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(polyline)
        }
        
        // Let the map view's built-in user tracking handle most of the camera updates
        if showUserLocation && !context.coordinator.isUserInteracting {
            mapView.userTrackingMode = .follow
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(locationManager: locationManager)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var locationManager: LocationService
        var isUserInteracting = false
        var returnTimer: Timer?
        
        init(locationManager: LocationService) {
            self.locationManager = locationManager
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 4
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
        
        // Handle map view region changes
        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            guard let view = mapView.subviews.first else { return }
            
            // Check if change is user-initiated by looking for touch or gesture
            if view.gestureRecognizers?.contains(where: { $0.state == .began || $0.state == .changed }) ?? false {
                isUserInteracting = true
                returnTimer?.invalidate()
            }
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            guard isUserInteracting else { return }
            
            // Only start return timer if this was a user interaction
            returnTimer?.invalidate()
            returnTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
                guard let self = self else { return }
                self.isUserInteracting = false
                
                // Smoothly return to user tracking
                UIView.animate(withDuration: 1.0) {
                    mapView.userTrackingMode = .follow
                }
            }
        }
    }
}
