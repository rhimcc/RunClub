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
    @Environment(\.dismiss) var dismiss
    @State private var showSignUp: Bool = false
    @StateObject var authViewModel: AuthViewModel

    var body: some View {
        if (authViewModel.isSignedIn) {
            MainView(authViewModel: authViewModel)
                .navigationBarBackButtonHidden(true)

        } else {
            VStack {
                Spacer()
                Text("Sign In")
                    .font(.title)
                    .bold()
                Spacer()
                VStack {
                    HStack {
                        VStack (alignment: .trailing){
                            Text("Email")
                                .bold()
                                .padding(.bottom)
                            Text("Password")
                                .bold()
                        }
                        VStack {
                            TextField("Email", text: $email)
                                .textFieldStyle(.roundedBorder)
                            SecureField("Password", text: $password)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                    
                }
                Button {
                    authViewModel.signIn(withEmail: email, password: password)
                } label : {
                    Text("SIGN IN")
                        .bold()
                }.buttonStyle(.borderedProminent)
                    .tint(.black)
                    .padding(20)
                    .disabled(email.isEmpty || password.isEmpty)
                
                HStack {
                    Text("Dont have an account?")
                    NavigationLink {
                        SignUpView(authViewModel: authViewModel)
                    } label: {
                        Text("Create an account")
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
    SignInView(authViewModel: AuthViewModel())
}
