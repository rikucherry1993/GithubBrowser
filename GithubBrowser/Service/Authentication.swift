//
//  Authentication.swift
//  GithubBrowser
//
//  Created by rikucherry on 2022/03/11.
//

import SwiftUI

/// Refer to:
/// [A good guide to login flow](https://github.com/StewartLynch/My-Secure-App---Part1-Completed/tree/main)
class Authentication: ObservableObject {
    
    // Track if login succeeded
    @Published var isValidated = false
    
    func updateValidation(success: Bool) {
        withAnimation {
            DispatchQueue.main.async {
                self.isValidated = success
            }
        }
    }
}
