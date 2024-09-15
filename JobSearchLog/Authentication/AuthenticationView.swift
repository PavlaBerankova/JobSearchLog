//
//  AuthenticationView.swift
//  JobSearchLog
//
//  Created by Pavla Beránková on 15.09.2024.
//

import SwiftUI

struct AuthenticationView: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    SignInEmailView()
                } label: {
                    Text("Sign In with Email")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Sign In")
        }
    }
}

#Preview {
    AuthenticationView()
}
