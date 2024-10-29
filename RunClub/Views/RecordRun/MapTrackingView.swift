//
//  MapViewRepresentable 2.swift
//  RunClub
//
//  Created by Alex Fogg on 29/10/2024.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapViewRepresentable: UIViewRepresentable {
    var showUserLocation: Bool
    @ObservedObject var locationManager: LocationService
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = showUserLocation
        
        if showUserLocation {
            mapView.userTrackingMode = .follow
        } else {
            if let firstLocation = locationManager.locations.first {
                let region = MKCoordinateRegion(
                    center: firstLocation.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                )
                mapView.setRegion(region, animated: false)
            }
        }
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeOverlays(mapView.overlays)
        
        if locationManager.locations.count > 1 {
            let coordinates = locationManager.locations.map { $0.coordinate }
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(polyline)
        }
        
        if showUserLocation && !context.coordinator.isUserInteracting {
            mapView.setUserTrackingMode(.follow, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(locationManager: locationManager, showUserLocation: showUserLocation)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var locationManager: LocationService
        var isUserInteracting = false
        var returnTimer: Timer?
        let showUserLocation: Bool
        
        init(locationManager: LocationService, showUserLocation: Bool) {
            self.locationManager = locationManager
            self.showUserLocation = showUserLocation
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
        
        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            guard showUserLocation else { return }
            
            if let view = mapView.subviews.first,
               view.gestureRecognizers?.contains(where: { $0.state == .began || $0.state == .changed }) ?? false {
                isUserInteracting = true
                returnTimer?.invalidate()
            }
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            guard showUserLocation && isUserInteracting else { return }
            
            returnTimer?.invalidate()
            returnTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
                guard let self = self else { return }
                self.isUserInteracting = false
                
                let currentRegion = mapView.region
                
                guard let userLocation = mapView.userLocation.location else { return }
                let targetRegion = MKCoordinateRegion(
                    center: userLocation.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                )
                
                UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut) {
                    mapView.setRegion(targetRegion, animated: true)
                } completion: { _ in
                    mapView.setUserTrackingMode(.follow, animated: true)
                }
            }
        }
    }
}
