//
//  MapSnapshotPrefetcher.swift
//  RunClub
//
//  Created by Alex Fogg on 29/10/2024.
//

import Foundation
import MapKit



class MapSnapshotPrefetcher {
    static let shared = MapSnapshotPrefetcher()
    private var prefetchQueue = OperationQueue()
    
    private init() {
        prefetchQueue.maxConcurrentOperationCount = 3
    }
    
    func prefetchSnapshots(for runs: [Run]) {
        for run in runs {
            let cacheKey = MapSnapshotCache.shared.generateCacheKey(for: run.locations)
            
            guard MapSnapshotCache.shared.getImage(forKey: cacheKey) == nil else {
                continue
            }
            
            prefetchQueue.addOperation {
                let options = MKMapSnapshotter.Options()
            }
        }
    }
}
