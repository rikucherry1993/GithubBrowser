//
//  ContentView.swift
//  GithubBrowser
//
//  Created by rikucherry on 2022/03/11.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var authentication: Authentication
    
    var body: some View {
        ZStack {
            Color("BackgroundBlack").edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Image("cactus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 160, height: 160, alignment: .center)
                    .padding(.vertical, 60)
                Spacer()
                VStack {
                    
                    // Text field for username
                    LoginTextField(hintString: "Username", inputString: $viewModel.credential.username)
                    
                    Spacer().frame(height: 20)
                    
                    // Text field for password
                    LoginTextField(hintString: "Password", inputString: $viewModel.credential.password
                                   , isSecure: true)
                    
                    Spacer().frame(height: 50)
                    
                    LoginButton(label: "Sign in" ){
                        viewModel.performLogin()
                    }
                    .disabled(viewModel.loginDisabled)
                }.padding()
                
                Spacer()
            }
            .alert(item: $viewModel.error) { error in
                return Alert(title: Text("Error"),
                             message: Text(String(describing:error)),
                             dismissButton:.cancel())
            }
            
            if viewModel.state == .loading {
                ProgressView()
            }
            
        }.onChange(of: viewModel.state) { state in
            // This is how you execute a closure in viewbuilder!
            if state == .finish {
                authentication.updateValidation(success: true)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(Authentication())
    }
}
