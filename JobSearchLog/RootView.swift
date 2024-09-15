//
//  RootView.swift
//  JobSearchLog
//
//  Created by Pavla Beránková on 14.09.2024.
//

import SwiftUI

struct RootView: View {
    @State private var showSignInView = false

    var body: some View {
        ZStack {
            NavigationStack {
                SettingsView(showSignInView: $showSignInView)
            }
            .onAppear {
                // Check if user is authenticated
                let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
                self.showSignInView = authUser == nil
            }
            .fullScreenCover(isPresented: $showSignInView) {
                NavigationStack {
                    AuthenticationView()
                }
            }
        }
    }
}

#Preview {
    RootView()
}
