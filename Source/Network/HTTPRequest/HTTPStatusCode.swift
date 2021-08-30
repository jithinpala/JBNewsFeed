//
//  HTTPStatusCode.swift
//  JBNewsFeed
//
//  Created by Jithin Balan on 31/8/21.
//

import Foundation

enum HTTPStatusCode: Int, CaseIterable {
    case success = 200

    case badRequest = 400

    case unAuthorized = 401

    case forbidden = 403

    case notFound = 404

    case tooManyRequests = 429

    case internalServerError = 500

    case serverUnavailable = 503

    case undefined = -1

    // MARK: - Initialisation

    init(rawValue: Int) {
        switch rawValue {
        case 200 ... 299:
            self = .success
        default:
            let statusCode = HTTPStatusCode.allCases.first(where: { $0.rawValue == rawValue })
            self = statusCode ?? .undefined
        }
    }
}
