//
//  LoginViewModel.swift
//  GithubBrowser
//
//  Created by rikucherry on 2022/03/11.
//

import Foundation

/// A viewmodel fetches log in results from LoginManager
class LoginViewModel: ObservableObject {
    
    @Published var state: ViewModelState = .idle
    // username and password
    @Published var credential = Credential()
    @Published var error: MyError?
    
    
    var loginDisabled: Bool {
        credential.username.isEmpty || credential.password.isEmpty || state == .loading
    }
    
    
    func performLogin() {
        self.state = .loading
        // Reset session everytime attempting to login.
        URLSession.shared.reset{
            print("Start fetching login page...")
            LoginManager.getLoginPage {result in
                switch result {
                case .failure(let error):
                    self.state = .error
                    self.error = error
                    self.credential = Credential()
                    print(error)
                case .success(let content):
                    self.postLoginData(content: content)
                }
            }
        }
    }
   
    
    private func postLoginData(content: String) {
        state = .loading
        print("Start posting credentials...")
        
        LoginManager.postCredential(credential, content: content) {result in
            switch result {
            case .failure(let error):
                self.state = .error
                self.error = error
                self.credential = Credential()
                print(error)
            case .success():
                self.state = .finish
                print("Login successful")
            }
        }
    }
}
