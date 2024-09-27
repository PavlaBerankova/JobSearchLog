//
//  RootView.swift
//  JobSearchLog
//
//  Created by Pavla Beránková on 14.09.2024.
//

import SwiftUI

struct RootView: View {
    @State private var showAuthenticationView = false

    var body: some View {
        ZStack {
            NavigationStack {
                SettingsView(showAuthenticationView: $showAuthenticationView)
            }
            .onAppear {
                // Check if user is authenticated
                let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
                self.showAuthenticationView = authUser == nil
            }
            .fullScreenCover(isPresented: $showAuthenticationView) {
                NavigationStack {
                    AuthenticationView(showAuthenticationView: $showAuthenticationView)
                }
            }
        }
    }
}

#Preview {
    RootView()
}
