//
//  LogInEmailView.swift
//  JobSearchLog
//
//  Created by Pavla Beránková on 21.09.2024.
//

import SwiftUI

struct LogInEmailView: View {
    @EnvironmentObject var appState: AppState
    @Binding var isAuthenticated: Bool
    @State private var email = String()
    @State private var password = String()

    var body: some View {
        NavigationStack {
            VStack {
                Group {
                    TextField("Your Email...", text: $email)
                    SecureField("Password...", text: $password)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

                Button {
                    Task {
                        do {
                            try await appState.logIn(email: email, password: password)
                            self.isAuthenticated = true
                        } catch {
                            print("Login failed: \(error)")
                        }
                        //                       try await appState.logIn(email: email ,password: password)
                        //                       appState.isAuthenticated = true
                    }
                } label: {
                    Text("Log In")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                Button {
                    Task {
                        do {
                            try await appState.resetPassword()
                        }
                    }
                    print("Your password has been reset.")
                } label: {
                    Text("Forgot your password?")
                }
            }
            .padding()
            .navigationTitle("Log In with Email")

            Spacer()
        }
    }
}

#Preview {
    LogInEmailView(isAuthenticated: .constant(false))
        .environmentObject(AppState())
}
