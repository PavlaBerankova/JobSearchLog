//
//  LogInEmailView.swift
//  JobSearchLog
//
//  Created by Pavla Beránková on 21.09.2024.
//

import SwiftUI

struct LogInEmailView: View {
    @StateObject var model = UserAuthViewModel()
    @State private var email = String()
    @State private var password = String()
    @Binding var showAuthenticationView: Bool

    var body: some View {
        NavigationStack {
            VStack {
                Group {
                    TextField("Your Email...", text: $model.email)
                    SecureField("Password...", text: $password)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

                Button {
                    Task {
                       try await model.logIn(email: email ,password: password)
                        showAuthenticationView.toggle()
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
    LogInEmailView(showAuthenticationView: .constant(false))
}
