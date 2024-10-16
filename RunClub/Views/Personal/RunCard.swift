//
//  RunCard.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import SwiftUI

struct RunCard: View {
    var body: some View {
        VStack {
            Text("Date")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5)
            HStack {
                Text("Start time")
                Spacer()
                Text("End time")
            }
            HStack {
                Text("Start area")
                Spacer()
                Text("Destination")
            }
            Spacer().frame(height: 20)
            HStack {
                Text("kms")
                Spacer()
                Text("Total time")
                Spacer()
                Text("Pace")
            }
        }.padding()
            .shadow(color: .black.opacity(0.2), radius: 5)

            
    }
}

#Preview {
    RunCard()
}
