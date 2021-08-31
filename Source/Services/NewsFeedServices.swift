//
//  NewsFeedServices.swift
//  JBNewsFeed
//
//  Created by Jithin Balan on 31/8/21.
//

import Foundation

typealias NewsFeedServicesResult = (Result <News, NewsFeedServicesError>) -> Void

protocol NewsFeedServicesProtocol {
    func fetchNewsFeed(pagination: Int, completion: @escaping NewsFeedServicesResult)
}

enum NewsFeedServicesError: Error {
    case failedToParseNewsFeed
    case failedToFetchNewsFeed
    case invalidRequest
    
    init(error: NSError) {
        if error is DecodingError {
            self = .failedToParseNewsFeed
            return
        }
        self = .failedToFetchNewsFeed
    }
}

final class NewsFeedServices: NewsFeedServicesProtocol {
    
    private enum QueryItem {
        static let query = "q"
        static let queryValue = "Tesla"
        static let page = "page"
        static let pageSize = "page_size"
        static let pageSizeValue = "25"
    }
        
    private let networkService = JBNetworkService()
    
    private var endPoint: String {
        "https://api.newscatcherapi.com/v2/search"
    }
    
    func fetchNewsFeed(pagination: Int, completion: @escaping NewsFeedServicesResult) {
        guard let request = makeRequest(pagination)
        else {
            completion(.failure(.invalidRequest))
            return
        }
        networkService.genericDataTask(withRequest: request) { result in
            switch result {
            case let .success((_, data)):
                do {
                    let newsFeed = try JSONDecoder().decode(News.self, from: data)
                    completion(.success(newsFeed))
                } catch (_) {
                    completion(.failure(.failedToParseNewsFeed))
                }
            case let .failure(error):
                let newsFeedError = NewsFeedServicesError(error: error as NSError)
                completion(.failure(newsFeedError))
            }
        }
    }
    
    private func makeRequest(_ pagination: Int) -> URLRequest? {
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
