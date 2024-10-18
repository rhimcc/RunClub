//
//  PostView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 16/10/2024.
//

import SwiftUI

struct PostView: View {
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Circle()
                        .fill(.gray)
                        .frame(width: 40, height: 40)
                    Text("pfp")
                }
                VStack {
                    HStack {
                        Text("Username")
                        Spacer()
                        Text("time")
                    }
                    HStack {
                        Text("Club name")
                        Spacer()
                    }
                }
                
            }.padding(10)
            
            Text("Message content")
                .padding()
        }
        .background(RoundedRectangle(cornerRadius: 20).stroke(.gray, lineWidth: 3))
    }
}

#Preview {
    PostView()
}
