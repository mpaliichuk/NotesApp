//
//  ContentView.swift
//  EmailPassLogin
//
//  Created by Marian Paliichuk on 03.08.2024.
//

import SwiftUI
import FirebaseAuth

//Google Login
struct ContentView: View {
    @State private var userLoggedIn = (Auth.auth().currentUser != nil)

    var body: some View {
        VStack {
            if userLoggedIn {
                Home()
            } else {
                CombinedLoginView()
            }
        }.onAppear{
            //Firebase state change listeneer
            Auth.auth().addStateDidChangeListener{ auth, user in
                if (user != nil) {
                    userLoggedIn = true
                } else {
                    userLoggedIn = false
                }
            }
        }
    }
}
////Firebase login
//struct ContentView: View {
//    @State private var isLoggedIn = false
//    
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                if isLoggedIn {
//                    Text("Welcome!")
//                    Button(action: logout) {
//                        Text("Logout")
//                            .padding()
//                            .background(Color.red)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                } else {
//                    NavigationLink(destination: LoginView()) {
//                        Text("Login")
//                            .padding()
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//
//                    NavigationLink(destination: RegisterView()) {
//                        Text("Register")
//                            .padding()
//                            .background(Color.green)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                }
//            }
//        }
//    }
//
//    private func logout() {
//        do {
//            try Auth.auth().signOut()
//            isLoggedIn = false
//        } catch {
//            print("Error signing out: \(error.localizedDescription)")
//        }
//    }
//}

