//
//  PersonalView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 15/10/2024.
//

import SwiftUI

struct PersonalView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("Personal Stats")
                    .padding(.top, 10)
                    .font(.title)
                    .bold()
                
                ScrollView(.horizontal) {
                    RunCard()
                        .frame(width: UIScreen.main.bounds.width - 60)
                }
                //ForEach run: Run Card
                Line()
                Spacer()
                // Graph
                
                NavigationLink {
                    RecordRunView()
                } label: {
                    Text("record run")
                }
                
            }
        }
    }
}

#Preview {
    PersonalView()
}
