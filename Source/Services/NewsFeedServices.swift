//
//  NewsFeedServices.swift
//  JBNewsFeed
//
//  Created by Jithin Balan on 31/8/21.
//

import Foundation

typealias NewsFeedServicesResult = (Result <News, NSError>) -> Void

protocol NewsFeedServicesProtocol {
    func fetchNewsFeed(completion: @escaping NewsFeedServicesResult)
}

final class NewsFeedServices: NewsFeedServicesProtocol {
    
    private enum QueryItem {
        static let query = "q"
        static let queryValue = "Tesla"
        static let page = "page"
        static let pageSize = "page_size"
        static let pageSizeValue = "10"
    }
        
    private let network = JBNetworkService()
    
    private var endPoint: String {
        "https://api.newscatcherapi.com/v2/search"
    }
    
    func fetchNewsFeed(completion: @escaping NewsFeedServicesResult) {
        guard let request = makeRequest()
        else { return }
        network.genericDataTask(withRequest: request) { result in
            switch result {
            case let .success((_, data)):
                do {
                    let newsFeed = try JSONDecoder().decode(News.self, from: data)
                    completion(.success(newsFeed))
                } catch (let error) {
                    print(error)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    private func makeRequest() -> URLRequest? {
        guard let url = newsFeedURL() else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    private func newsFeedURL() -> URL? {
        guard var urlComponents = URLComponents(string: endPoint) else { return nil }
        let queryItem = URLQueryItem(name: QueryItem.query, value: QueryItem.queryValue)
        let pageItem = URLQueryItem(name: QueryItem.page, value: "1")
        let pageSizeItem = URLQueryItem(name: QueryItem.pageSize, value: QueryItem.pageSizeValue)
        urlComponents.queryItems = [queryItem, pageItem, pageSizeItem]
        return urlComponents.url
    }
}
