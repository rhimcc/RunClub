//
//  StaticMapView.swift
//  RunClub
//
//  Created by Alex Fogg on 29/10/2024.
//

import SwiftUI
import CoreLocation
import MapKit

struct StaticMapView: View {
    let locations: [CLLocation]
    @State private var snapshot: UIImage?
    private let cacheKey: String
    
    init(locations: [CLLocation]) {
        self.locations = locations
        self.cacheKey = MapSnapshotCache.shared.generateCacheKey(for: locations)
    }
    
    var body: some View {
        Group {
            if let snapshot = snapshot {
                Image(uiImage: snapshot)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
            }
        }
        .frame(height: 180)
        .cornerRadius(12)
        .onAppear {
            loadSnapshot()
        }
    }
    
    private func loadSnapshot() {
        if let cachedImage = MapSnapshotCache.shared.getImage(forKey: cacheKey) {
            self.snapshot = cachedImage
            return
        }
        generateSnapshot()
    }
    
    private func generateSnapshot() {
        guard !locations.isEmpty else { return }
        
        let coordinates = locations.map { $0.coordinate }
        var minLat = coordinates[0].latitude
        var maxLat = coordinates[0].latitude
        var minLon = coordinates[0].longitude
        var maxLon = coordinates[0].longitude
        
        for coordinate in coordinates {
            minLat = min(minLat, coordinate.latitude)
            maxLat = max(maxLat, coordinate.latitude)
            minLon = min(minLon, coordinate.longitude)
            maxLon = max(maxLon, coordinate.longitude)
        }
        
        let latPadding = (maxLat - minLat) * 0.15
        let lonPadding = (maxLon - minLon) * 0.15
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) + (latPadding * 2),
            longitudeDelta: (maxLon - minLon) + (lonPadding * 2)
        )
        
        let region = MKCoordinateRegion(center: center, span: span)
        
        let options = MKMapSnapshotter.Options()
        options.region = region
        options.size = CGSize(width: UIScreen.main.bounds.width - 64, height: 180)
        options.scale = UIScreen.main.scale
        options.mapType = .standard
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            guard let snapshot = snapshot else {
                print("Snapshot error: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            
            UIGraphicsBeginImageContextWithOptions(snapshot.image.size, true, snapshot.image.scale)
            snapshot.image.draw(at: .zero)
            
            if let context = UIGraphicsGetCurrentContext() {
                context.setLineWidth(3)
                context.setStrokeColor(Color.mossGreen.cgColor ?? UIColor.systemBlue.cgColor)
                
                let points = coordinates.map { coordinate in
                    snapshot.point(for: coordinate)
                }
                
                context.move(to: points[0])
                for point in points.dropFirst() {
                    context.addLine(to: point)
                }
                
                context.strokePath()
            }
            
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let finalImage = finalImage {
                MapSnapshotCache.shared.store(image: finalImage, forKey: cacheKey)
                DispatchQueue.main.async {
                    self.snapshot = finalImage
                }
            }
        }
    }
}
