//
//  SignInView.swift
//  JobSearchLog
//
//  Created by Pavla Beránková on 14.09.2024.
//

import SwiftUI

struct SignUpEmailView: View {
    @StateObject var model = UserAuthViewModel()
    @Binding var showAuthenticationView: Bool
    @State private var password = String()

    var body: some View {
        NavigationStack {
            VStack {
                Group {
                    TextField("Email...", text: $model.email)
                    SecureField("Password...", text: $password)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

                Button {
                    Task {
                            model.signUp(inputPassword: password)
                            showAuthenticationView = false
                            print("Your account has been created")
                            return
                    }
                } label: {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Sign Up with Email")

            Spacer()
        }
    }
}

#Preview {
    SignUpEmailView(showAuthenticationView: .constant(false))
}
