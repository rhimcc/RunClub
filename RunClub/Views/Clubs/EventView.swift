//
//  EventView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import SwiftUI

struct EventView: View {
    var body: some View {
        ScrollView {
            VStack {
                EventRow()
                EventRow()
                EventRow()
                EventRow()
            }.padding()
        }

        // Event row
    }
}

#Preview {
    EventView()
}
