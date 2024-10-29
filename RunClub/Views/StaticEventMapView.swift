//
//  StaticEventMapView.swift
//  RunClub
//
//  Created by Alex Fogg on 29/10/2024.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation

struct StaticEventMapView: View {
    let coordinate: CLLocationCoordinate2D
    @State private var snapshot: UIImage?
    private let cacheKey: String
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.cacheKey = MapSnapshotCache.shared.generateEventCacheKey(for: coordinate)
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
        .frame(width: 180, height: 120)
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
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        let options = MKMapSnapshotter.Options()
        options.region = region
        options.size = CGSize(width: 180, height: 120)
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
                // Draw pin
                let pinPoint = snapshot.point(for: coordinate)
                
                // Draw circle
                let circleRadius: CGFloat = 5
                context.setFillColor(UIColor(named: "MossGreen")?.cgColor ?? UIColor.green.cgColor)
                context.addArc(center: pinPoint, radius: circleRadius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
                context.fillPath()
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
