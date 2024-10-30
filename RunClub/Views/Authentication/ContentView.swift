//
//  ContentView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 14/10/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                // Logo area
//                Circle()
//                    .fill(Color("MossGreen"))
//                    .frame(width: 100, height: 100)
//                    .overlay(
//                        Image(systemName: "figure.run")
//                            .font(.system(size: 50))
//                            .foregroundColor(.white)
//                    )
//                    .padding(.bottom, 16)
//                
//                Text("Run Club")
//                    .font(.system(size: 40, weight: .bold))
//                    .padding(.bottom, 40)
                Image("AppIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .padding(.bottom, 16)

                Text("Run Club")
                    .font(.system(size: 40, weight: .bold))
                    .padding(.bottom, 40)
                
                Spacer()
                
                // Buttons
                VStack(spacing: 16) {
                    NavigationLink {
                        SignInView(authViewModel: authViewModel)
                    } label: {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color("MossGreen"))
                            .cornerRadius(10)
                    }
                    
                    NavigationLink {
                        SignUpView(authViewModel: authViewModel)
                    } label: {
                        Text("Create Account")
                            .font(.headline)
                            .foregroundColor(Color("MossGreen"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color("MossGreen").opacity(0.1))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
            .background(Color.white)
        }
    }
}

#Preview {
    ContentView(authViewModel: AuthViewModel())
}
