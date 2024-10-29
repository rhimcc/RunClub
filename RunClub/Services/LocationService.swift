//
//  LocationService.swift
//  RunClub
//
//  Created by Alex Fogg on 23/10/2024.
//

import Foundation
import CoreLocation
import MapKit
import ActivityKit

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager?
    @Published var locations: [CLLocation] = []
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    @Published var isTracking = false
    @Published var distance: Double = 0
    @Published var currentPace: TimeInterval = 0
    @Published var elapsedTime: TimeInterval = 0
    
    private var timer: Timer?
    var startTime: Date?
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = 10
        locationManager?.activityType = .fitness
    }
    
    private func hasBackgroundCapability() -> Bool {
        if let backgroundModes = Bundle.main.object(forInfoDictionaryKey: "UIBackgroundModes") as? [String] {
            return backgroundModes.contains("location")
        }
        return false
    }
    
    func requestPermission() {
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func startTracking() {
        guard let locationManager = locationManager else { return }
        
        let authStatus = locationManager.authorizationStatus
        guard authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways else {
            print("Location services not properly authorized")
            return
        }
        
        locations.removeAll()
        distance = 0
        currentPace = 0
        elapsedTime = 0
        isTracking = true
        startTime = Date()
        
        
        if hasBackgroundCapability() {
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.showsBackgroundLocationIndicator = true
            locationManager.pausesLocationUpdatesAutomatically = false
        }
        
        locationManager.startUpdatingLocation()
        self.startLiveActivity()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self, let startTime = self.startTime else { return }
            self.elapsedTime = Date().timeIntervalSince(startTime)
            if self.distance > 0 {
                self.currentPace = self.elapsedTime / (self.distance / 1000)
            }
            self.updateLiveActivity()
        }

    }
    
    func stopTracking() {
        isTracking = false
        locationManager?.stopUpdatingLocation()
        timer?.invalidate()
        timer = nil
        startTime = nil
        
        locationManager?.allowsBackgroundLocationUpdates = false
        self.endLiveActivity()
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard isTracking else { return }
        
        for newLocation in locations {
            if let lastLocation = self.locations.last {
                let distance = newLocation.distance(from: lastLocation)
                self.distance += distance
            }
            self.locations.append(newLocation)

            region = MKCoordinateRegion(
                center: newLocation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            )
        }
    }
    
}
extension LocationService {
    func startLiveActivity() {
        let attributes = RunActivityAttributes(runName: "Current Run")
        
        do {
            let initialContentState = RunActivityAttributes.ContentState(
                distance: 0,
                pace: 0,
                elapsedTime: 0
            )
            
            let activity = try Activity.request(
                attributes: attributes,
                contentState: initialContentState
            )
            print("Requested Live Activity: \(activity.id)")
        } catch {
            print("Error requesting Live Activity: \(error.localizedDescription)")
        }
    }

    func updateLiveActivity() {
        Task {
            for activity in Activity<RunActivityAttributes>.activities {
                let contentState = RunActivityAttributes.ContentState(
                    distance: self.distance,
                    pace: self.currentPace,
                    elapsedTime: self.elapsedTime
                )
                await activity.update(using: contentState)
            }
        }
    }
    
    func endLiveActivity() {
        Task {
            for activity in Activity<RunActivityAttributes>.activities {
                await activity.end(using: activity.contentState, dismissalPolicy: .immediate)
            }
        }
    }
}
