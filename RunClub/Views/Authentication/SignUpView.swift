import Foundation
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
                                    .autocapitalization(.words)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Last Name")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                TextField("Last", text: $lastName)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .autocapitalization(.words)
                            }
                        }
                        
                        // Username field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Username")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            TextField("Choose a username", text: $username)
                                .textFieldStyle(CustomTextFieldStyle())
                                .autocapitalization(.none)
                        }
                        
                        // Email field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            TextField("Enter your email", text: $email)
                                .textFieldStyle(CustomTextFieldStyle())
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                        }
                        
                        // Phone field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Phone")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            TextField("Enter your phone number", text: $phoneNumber)
                                .textFieldStyle(CustomTextFieldStyle())
                                .keyboardType(.phonePad)
                        }
                        
                        // Password fields
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            SecureField("Create a password", text: $password)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm Password")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            SecureField("Confirm your password", text: $confirmPassword)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                    }
                    
                    if let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .padding(.top, 8)
                    }
                    
                    Button {
                        if password == confirmPassword {
                            authViewModel.createAccount(withEmail: email, 
                                                     password: password, 
                                                     firstName: firstName, 
                                                     lastName: lastName, 
                                                     phoneNumber: phoneNumber, 
                                                     username: username)
                        } else {
                            authViewModel.errorMessage = "Passwords do not match"
                        }
                    } label: {
                        ZStack {
                            Text("Create Account")
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
                    .disabled(firstName.isEmpty || 
                             lastName.isEmpty || 
                             email.isEmpty || 
                             password.isEmpty || 
                             confirmPassword.isEmpty || 
                             username.isEmpty ||
                             authViewModel.isLoading)
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
