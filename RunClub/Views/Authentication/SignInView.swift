//
//  SignInView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 14/10/2024.
//

import SwiftUI

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @StateObject var authViewModel: AuthViewModel

    var body: some View {
        if (authViewModel.isSignedIn) {
            MainView(authViewModel: authViewModel)
                .navigationBarBackButtonHidden(true)
        } else {
            VStack(spacing: 24) {
                Text("Welcome Back")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.top, 40)
                
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        TextField("Enter your email", text: $email)
                            .textFieldStyle(CustomTextFieldStyle())
                            .autocapitalization(.none)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        SecureField("Enter your password", text: $password)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                }
                .padding(.top, 24)
                
                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding(.top, 8)
                }
                
                Button {
                    authViewModel.signIn(withEmail: email, password: password)
                } label: {
                    ZStack {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color("MossGreen"))
                            .cornerRadius(10)
                            .opacity(authViewModel.isLoading ? 0 : 1)
                        
                        if authViewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color("MossGreen"))
                                .cornerRadius(10)
                        }
                    }
                }
                .disabled(email.isEmpty || password.isEmpty || authViewModel.isLoading)
                .padding(.top, 16)
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                    NavigationLink {
                        SignUpView(authViewModel: authViewModel)
                    } label: {
                        Text("Create one")
                            .foregroundColor(Color("MossGreen"))
                    }
                }
                .font(.subheadline)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .background(Color.white)
        }
    }
}
