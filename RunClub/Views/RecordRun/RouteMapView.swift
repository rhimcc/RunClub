//
//  RouteMapView.swift
//  RunClub
//
//  Created by Alex Fogg on 23/10/2024.
//

import SwiftUI
import MapKit
import CoreLocation

struct RouteMapView: View {
    var showUserLocation: Bool
    
    struct MapViewRepresentable: UIViewRepresentable {
        var showUserLocation: Bool
        @ObservedObject var locationManager: LocationService
        
        func makeUIView(context: Context) -> MKMapView {
            let mapView = MKMapView()
            mapView.delegate = context.coordinator
            mapView.showsUserLocation = showUserLocation
            mapView.userTrackingMode = showUserLocation ? .follow : .none
            return mapView
        }
        
        func updateUIView(_ mapView: MKMapView, context: Context) {
            mapView.removeOverlays(mapView.overlays)
            
            if locationManager.locations.count > 1 {
                let coordinates = locationManager.locations.map { $0.coordinate }
                let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
                mapView.addOverlay(polyline)
            }
            
            if let lastLocation = locationManager.locations.last {
                let region = MKCoordinateRegion(
                    center: lastLocation.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                )
                mapView.setRegion(region, animated: true)
            }
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator()
        }
        
        class Coordinator: NSObject, MKMapViewDelegate {
            func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
                if let polyline = overlay as? MKPolyline {
                    let renderer = MKPolylineRenderer(polyline: polyline)
                    renderer.strokeColor = .blue
                    renderer.lineWidth = 4
                    return renderer
                }
                return MKOverlayRenderer(overlay: overlay)
            }
        }
    }
    
    @ObservedObject var locationManager: LocationService
    
    var body: some View {
        MapViewRepresentable(showUserLocation: showUserLocation, locationManager: locationManager)
            .edgesIgnoringSafeArea(.top)
    }
}
