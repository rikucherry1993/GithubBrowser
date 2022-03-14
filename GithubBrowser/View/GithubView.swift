//
//  GithubView.swift
//  GithubBrowser
//
//  Created by rikucherry on 2022/03/11.
//

import SwiftUI
import WebKit


struct GithubView: View {
    @EnvironmentObject var authentication: Authentication
    
    let url = "https://github.com/session"
    var request: URLRequest {
        URLRequest(url: URL(string: url)!)
    }
    
    var body: some View {
        ZStack {
            Color("BackgroundBlack").edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .trailing) {
                Button {
                    // Log out
                    URLSession.shared.reset {
                        authentication.updateValidation(success: false)
                    }
                } label: {
                    Text("Logout").padding()
                }.frame(height: 30)
                
                WebView(request)
            }
            
        }
    }
}

struct WebView: UIViewRepresentable {
    
    let request: URLRequest
    
    init(_ request: URLRequest) {
        self.request = request
    }
    
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.processPool = WKProcessPool()
        let cookies = HTTPCookieStorage.shared.cookies ?? [HTTPCookie]()
        cookies.forEach({
            config.websiteDataStore.httpCookieStore.setCookie($0)
        })
        
        return WKWebView(frame:.zero, configuration: config)
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
    
}


struct GithubView_Previews: PreviewProvider {
    static var previews: some View {
        GithubView().environmentObject(Authentication())
    }
}
