//
//  SignInView.swift
//  RunClub
//
//  Created by Rhianna McCormack on 14/10/2024.
//

import SwiftUI

struct SignUpView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var phoneNumber: String = ""
    @State private var username: String = ""
    @StateObject var authViewModel: AuthViewModel

    var body: some View {
        if (authViewModel.isSignedIn) {
            MainView(authViewModel: authViewModel)
                .navigationBarBackButtonHidden(true)
        } else {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Create Account")
                        .font(.system(size: 28, weight: .bold))
                        .padding(.top, 40)
                    
                    VStack(spacing: 16) {
                        // Name Fields
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("First Name")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                TextField("First", text: $firstName)
                                    .textFieldStyle(CustomTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Last Name")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                TextField("Last", text: $lastName)
                                    .textFieldStyle(CustomTextFieldStyle())
                            }
                        }
                        
                        // Other fields
                        FormField(title: "Username", placeholder: "Choose a username", text: $username)
                        FormField(title: "Email", placeholder: "Enter your email", text: $email)
                        FormField(title: "Phone", placeholder: "Enter your phone number", text: $phoneNumber)
                        FormField(title: "Password", placeholder: "Create a password", text: $password, isSecure: true)
                        FormField(title: "Confirm Password", placeholder: "Confirm your password", text: $confirmPassword, isSecure: true)
                    }
                    
                    Button {
                        authViewModel.createAccount(withEmail: email, password: password, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, username: username)
                    } label: {
                        Text("Create Account")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color("MossGreen"))
                            .cornerRadius(10)
                    }
                    .disabled(firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
                    .padding(.top, 16)
                    
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.gray)
                        NavigationLink {
                            SignInView(authViewModel: authViewModel)
                        } label: {
                            Text("Sign in")
                                .foregroundColor(Color("MossGreen"))
                        }
                    }
                    .font(.subheadline)
                }
                .padding(.horizontal, 24)
            }
            .background(Color.white)
        }
    }
}

#Preview {
    SignUpView(authViewModel: AuthViewModel())
}
