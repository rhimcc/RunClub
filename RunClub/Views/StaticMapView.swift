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
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        
        let rect = polyline.boundingMapRect
        let region = MKCoordinateRegion(rect)
        
        let options = MKMapSnapshotter.Options()
        options.region = region
        options.size = CGSize(width: UIScreen.main.bounds.width - 40, height: 180)
        options.scale = UIScreen.main.scale
        
        let snapshotter = MKMapSnapshotter(options: options)
        
        snapshotter.start { snapshot, error in
            guard let snapshot = snapshot else {
                print("Snapshot error: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            
            UIGraphicsBeginImageContextWithOptions(snapshot.image.size, true, snapshot.image.scale)
            snapshot.image.draw(at: .zero)
            
            if let context = UIGraphicsGetCurrentContext() {
                context.setLineWidth(4)
                context.setStrokeColor(UIColor.systemBlue.cgColor)
                
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
