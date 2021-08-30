//
//  JBNetworkError.swift
//  JBNewsFeed
//
//  Created by Jithin Balan on 30/8/21.
//

import Foundation

enum JBNetworkError: Error {
    
    case undefined(error: Error?)

    case notConnectedToInternet

    case networkTimeout

    case requestCancelled

    case badRequest(withStatusCode: HTTPStatusCode, responseError: Error?)
    
    init(_ error: Error) {
        let error = error as NSError
        switch error.code {
        case NSURLErrorTimedOut where error.domain == NSURLErrorDomain:
            self = .networkTimeout
        case NSURLErrorNotConnectedToInternet where error.domain == NSURLErrorDomain:
            self = .notConnectedToInternet
        case NSURLErrorCancelled where error.domain == NSURLErrorDomain:
            self = .requestCancelled
        default:
            self = .undefined(error: error)
        }
    }
}
