//
//  SignInView.swift
//  JobSearchLog
//
//  Created by Pavla Beránková on 14.09.2024.
//

import SwiftUI

struct SignInEmailView: View {
    @StateObject var model = SignInEmailViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                Group {
                    TextField("Email...", text: $model.email)
                    SecureField("Password...", text: $model.password)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

                Button {
                    model.signIn()
                } label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Sign In with Email")

            Spacer()
        }
    }
}

#Preview {
    SignInEmailView()
}
