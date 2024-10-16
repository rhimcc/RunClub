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
            EventRow()
            EventRow()
            EventRow()
            EventRow()
        }

        // Event row
    }
}

#Preview {
    EventView()
}
