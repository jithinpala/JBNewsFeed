//
//  NewsFeedService.swift
//  JBNewsFeed
//
//  Created by Jithin Balan on 31/8/21.
//

import Foundation

typealias NewsFeedServiceResult = (Result <News, NewsFeedServiceError>) -> Void

protocol NewsFeedServiceProtocol {
    func fetchNewsFeed(pagination: Int, completion: @escaping NewsFeedServiceResult)
}

enum NewsFeedServiceError: Error {
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

final class NewsFeedService: NewsFeedServiceProtocol {
    
    private let endPoint: NewsFeedEndPoints = NewsFeedEndPoints()
    private let networkService = JBNetworkService()
    
    func fetchNewsFeed(pagination: Int, completion: @escaping NewsFeedServiceResult) {
        guard let request = endPoint.makeRequest(pagination)
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
                let newsFeedError = NewsFeedServiceError(error: error as NSError)
                completion(.failure(newsFeedError))
            }
        }
    }
}
