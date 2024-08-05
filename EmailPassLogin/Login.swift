import SwiftUI
import FirebaseAuth

struct CombinedLoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var googleError: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Email/Password Login
                VStack {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: emailPasswordLogin) {
                        Text("Login with Email")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                .padding()
                
                // Google Sign-In
                VStack {
                    Button(action: {
                        Task {
                            do {
                                try await Authentication().googleOauth()
                            } catch let e {
                                print(e)
                                googleError = e.localizedDescription
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "person.badge.key.fill")
                            Text("Sign in with Google")
                        }
                        .padding(8)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    if !googleError.isEmpty {
                        Text(googleError)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                
                // Navigation to Register
                NavigationLink(destination: RegisterView()) {
                    HStack {
                        Image(systemName: "person.badge.plus")
                        Text("Register")
                    }
                    .padding(8)
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .navigationTitle("Login")
        }
    }
    
    private func emailPasswordLogin() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                errorMessage = "User logged in successfully"
            }
        }
    }
}

struct CombinedLoginView_Previews: PreviewProvider {
    static var previews: some View {
        CombinedLoginView()
    }
}
