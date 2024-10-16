//
//  ContentView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 14/10/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    var body: some View {
        NavigationStack {
            Spacer()
            Text("Run Club")
                .font(.system(size: 50))
                .bold()
                
            Spacer()
            
            NavigationLink {
                SignInView()
            } label : {
                Text("SIGN IN")
                    .bold()
            }.buttonStyle(.borderedProminent)
                .padding(.vertical)
                .tint(.black)

            NavigationLink {
                SignUpView()
            } label : {
                Text("SIGN UP")
                    .bold()
            }.buttonStyle(.borderedProminent)
                .tint(.black)

            Spacer()
            Spacer()
            
        }
    }

  
}

#Preview {
    ContentView()
}
