//
//  Errors.swift
//  GithubBrowser
//
//  Created by rikucherry on 2022/03/11.
//

import Foundation

typealias ResultHandler<T> = (Result<T, MyError>) -> Void

/// Categorizes customized errors.
enum MyError: Error, CustomStringConvertible, Identifiable  {
    case invalidRequest
    case invalidResponse
    case httpError(code: Int)
    case other(Error)
    case error(msg: String)
    
    var id: String {
        String(describing: self)
    }
    
    var description: String {
        switch self {
        case .invalidRequest: return "Invalid request"
        case .invalidResponse: return "Invalid response"
        case .httpError(let code): return "HTTP Error occured. Error code: \(code)"
        case .error(let msg): return msg
        case .other(let error): return String(describing: error)
        }
    }
}
