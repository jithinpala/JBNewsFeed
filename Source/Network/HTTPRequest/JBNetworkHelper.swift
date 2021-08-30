//
//  JBNetworkHelper.swift
//  JBNewsFeed
//
//  Created by Jithin Balan on 30/8/21.
//

import Foundation

extension URLRequest {

    mutating func addHeaders(headers: HTTPHeaders?, overwrite: Bool = true) {
        guard let headers = headers, !headers.isEmpty else { return }
        for (key, header) in headers {
            if overwrite || value(forHTTPHeaderField: key) == nil {
                setValue(header, forHTTPHeaderField: key)
            }
        }
    }
}
