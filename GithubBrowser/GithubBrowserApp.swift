//
//  GithubBrowserApp.swift
//  GithubBrowser
//
//  Created by rikucherry on 2022/03/11.
//

import SwiftUI

@main
struct GithubBrowserApp: App {
    @StateObject var authentication = Authentication()
    
    var body: some Scene {
        WindowGroup {
            // Switch first view depending on authentication result
            if authentication.isValidated {
                GithubView().environmentObject(authentication)
            } else {
                LoginView().environmentObject(authentication)
            }
        }
    }
}
