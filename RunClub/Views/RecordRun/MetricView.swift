//
//  MetricView.swift
//  RunClub
//
//  Created by Alex Fogg on 23/10/2024.
//

import SwiftUI

struct MetricView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            Text(value)
                .font(.title2)
                .bold()
        }
    }
}
