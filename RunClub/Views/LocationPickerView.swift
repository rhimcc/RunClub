//
//  LocationPickerView.swift
//  RunClub
//
//  Created by Alex Fogg on 27/10/2024.
//


import SwiftUI
import MapKit
import FirebaseFirestore

struct LocationPickerView: View {
    @Binding var selectedLocation: CLLocationCoordinate2D?
    @StateObject private var viewModel = LocationPickerViewModel()
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.region, interactionModes: .all)
                .frame(height: 200)
                .cornerRadius(12)
                .onChange(of: viewModel.region.center.latitude) {
                    selectedLocation = viewModel.updateSelectedLocation()
                }
                .onChange(of: viewModel.region.center.longitude) {
                    selectedLocation = viewModel.updateSelectedLocation()
                }
            
            Image(systemName: "mappin.circle.fill")
                .font(.title)
                .foregroundColor(Color("MossGreen"))
                .background(Circle().fill(.white).frame(width: 25, height: 25))
        }
    }
}
