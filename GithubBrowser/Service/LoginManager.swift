//
//  LoginManager.swift
//  GithubBrowser
//
//  Created by rikucherry on 2022/03/11.
//


import Foundation
import SwiftSoup


/// A struct for managing login request execution
struct LoginManager {
    static let urlString = "https://github.com/session"
    static let contentType = "application/x-www-form-urlencoded"
    
    /// Fetch the login page html in form of String.
    static func getLoginPage(handler: @escaping ResultHandler<String>) {
        guard let url = URL(string: urlString) else {
            handler(.failure(.invalidRequest))
            return
        }
        
        var requestGetPage = URLRequest(url: url)
        requestGetPage.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: requestGetPage) {
            data, response, error in
            
            DispatchQueue.main.async {
                if error != nil {
                    handler(.failure(.other(error!)))
                    return
                }
                
                if let safeData = data {
                    let content = String(data: safeData, encoding: .utf8)
                    handler(.success(content!))
                }
            }
        }.resume()
    }
    
    
    /// Post credentials to the service provider via HTTP request.
    ///
    /// - See also:  [A guide about how to achieve github login in python](https://stackoverflow.com/questions/38537963/how-can-i-use-post-from-requests-module-to-login-to-github/56205242#56205242)
    ///
    static func postCredential(_ credentials: Credential, content: String
                               , handler: @escaping ResultHandler<Void>) {
        guard let url = URL(string: urlString) else {
            handler(.failure(.invalidRequest))
            return
        }
        
        var requestPostLogin = URLRequest(url: url)
        requestPostLogin.setValue(contentType, forHTTPHeaderField: "Content-Type")
        requestPostLogin.httpMethod = "POST"
        
        var authToken: String = ""
        
        // retrieve the authenticity_token from page content
        do {
            let doc: Document = try SwiftSoup.parseBodyFragment(content)
            let body = doc.body()!
            let elements: Elements = try body.select("input")
            for element in elements {
                
                if try element.attr("name") == "authenticity_token" {
                    authToken = try element.attr("value")
                }
            }
        } catch let error {
            handler(.failure(.other(error)))
        }
        
        
        let requestBody = "commit=Sign in&login=\(credentials.username)&password=\(credentials.password)&authenticity_token=\(authToken)".data(using: .utf8)
        
        requestPostLogin.httpBody = requestBody
        
        
        URLSession.shared.dataTask(with: requestPostLogin) {
            data, response, error in
            
            DispatchQueue.main.async {
                if error != nil {
                    handler(.failure(.other(error!)))
                    return
                }
                
                if response == nil {
                    handler(.failure(.invalidResponse))
                    return
                }
                
                if let safeData = data {
                    let httpResponse = response as! HTTPURLResponse
                    let dataStr = String(data: safeData, encoding: .utf8)
                    
                    if httpResponse.statusCode == 200 {
                        // parse response data to check if logged in
                        do {
                            let doc: Document = try SwiftSoup.parse(dataStr!)
                            let body = doc.body()
                            if body?.hasClass("logged-in") == true {
                                handler(.success(()))
                            } else {
                                handler(.failure(.error(msg: "Login failed.")))
                                return
                            }
                        } catch let error {
                            handler(.failure(.other(error)))
                            return
                        }
                    } else {
                        handler(.failure(.httpError(code: httpResponse.statusCode)))
                        return
                    }
                }
            }
        }.resume()
    }
}
