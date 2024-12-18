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
            VStack {
                Spacer()
                Text("Sign Up")
                    .font(.title)
                    .bold()
                Spacer()
                VStack {
                    VStack (alignment: .leading){
                        
                        Text("Name")
                            .bold()
                        HStack {
                            TextField("First", text: $firstName)
                                .textFieldStyle(.roundedBorder)
                            
                            TextField("Last", text: $lastName)
                                .textFieldStyle(.roundedBorder)
                            
                        }
                        .padding(.bottom)
                        
                        Text("Username")
                        TextField("Username", text: $username)
                            .textFieldStyle(.roundedBorder)
                            .padding(.bottom)        
                        
                        Text("Email")
                        TextField("Email", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .padding(.bottom)
                        Text("Phone Number")
                        TextField("Phone Number", text: $phoneNumber)
                            .textFieldStyle(.roundedBorder)
                            .padding(.bottom)
                        
                        
                        Text("Password")
                            .bold()
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                            .padding(.bottom)
                        
                        Text("Confirm Password")
                            .bold()
                        SecureField("Confirm Password", text: $confirmPassword)
                            .textFieldStyle(.roundedBorder)
                        
                    }
                }
                
                Button {
                    authViewModel.createAccount(withEmail: email, password: password, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, username: username)
                  
                } label : {
                    Text("SIGN UP")
                        .bold()
                }.buttonStyle(.borderedProminent)
                    .tint(.black)
                    .padding(20)
                    .disabled(firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
                
                HStack {
                    Text("Already have an account?")
                    NavigationLink {
                        SignInView(authViewModel: authViewModel)
                    } label : {
                        Text("Sign In")
                            .underline()
                            .foregroundStyle(.black)
                    }
                }
                Spacer()
                Spacer()
                
                
            }.padding(.horizontal, 20)
        }
        
    }
}

#Preview {
    SignUpView(authViewModel: AuthViewModel())
}
