//
//  MapSnapshotCache.swift
//  RunClub
//
//  Created by Alex Fogg on 29/10/2024.
//

import Foundation
import UIKit
import CoreLocation


class MapSnapshotCache {
    static let shared = MapSnapshotCache()
    private var cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100
    }
    
    func store(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func generateCacheKey(for locations: [CLLocation]) -> String {
        guard let first = locations.first,
              let last = locations.last else { return "" }
        return "\(first.coordinate.latitude),\(first.coordinate.longitude)-\(last.coordinate.latitude),\(last.coordinate.longitude)"
    }
}
