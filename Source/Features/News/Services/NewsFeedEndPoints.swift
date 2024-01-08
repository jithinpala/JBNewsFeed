//
//  NewsFeedEndPoints.swift
//  JBNewsFeed
//
//  Created by Balan, Jithin on 9/1/2024.
//

import Foundation

final class NewsFeedEndPoints {
    private enum QueryItem {
        static let query = "q"
        static let queryValue = "Tesla"
        static let page = "page"
        static let pageSize = "page_size"
        static let pageSizeValue = "25"
    }

    private var endPoint: String {
        "https://api.newscatcherapi.com/v2/search"
    }

    func makeRequest(_ pagination: Int) -> URLRequest? {
        guard let url = newsFeedURL(pagination) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    private func newsFeedURL(_ pagination: Int) -> URL? {
        guard var urlComponents = URLComponents(string: endPoint) else { return nil }
        let queryItem = URLQueryItem(name: QueryItem.query, value: QueryItem.queryValue)
        let pageItem = URLQueryItem(name: QueryItem.page, value: "\(pagination)")
        let pageSizeItem = URLQueryItem(name: QueryItem.pageSize, value: QueryItem.pageSizeValue)
        urlComponents.queryItems = [queryItem, pageItem, pageSizeItem]
        return urlComponents.url
    }
}
