//
//  HomeView.swift
//  EmailPassLogin
//
//  Created by Marian Paliichuk on 03.08.2024.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @State private var isLoggedIn = true

    var body: some View {
        VStack {
            Text("Welcome!")
            NotesView()
            Button(action: logout) {
                Text("Logout")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
