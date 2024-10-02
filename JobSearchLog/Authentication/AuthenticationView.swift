//
//  AuthenticationView.swift
//  JobSearchLog
//
//  Created by Pavla Beránková on 15.09.2024.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var appState: AppState
    @Binding var isAuthenticated: Bool

    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    SignUpEmailView(isAuthenticated: $isAuthenticated)
                        .environmentObject(appState)
                } label: {
                    Text("Sign Up with Email")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                NavigationLink {
                    LogInEmailView(isAuthenticated: $isAuthenticated)
                        .environmentObject(appState)
                } label: {
                    Text("You have already an account?")
                }
            }
            .padding()
            .navigationTitle("Sign Up")
        }
    }
}

#Preview {
    AuthenticationView(isAuthenticated: .constant(false))
        .environmentObject(AppState())
}
