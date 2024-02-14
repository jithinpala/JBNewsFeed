//
//  NewsFeedService.swift
//  JBNewsFeed
//
//  Created by Jithin Balan on 31/8/21.
//

import Combine
import Foundation

typealias NewsFeedServiceModelResult = Result<News, NewsFeedServiceError>
typealias NewsFeedServiceCallBack = (NewsFeedServiceModelResult) -> Void

protocol NewsFeedServiceProtocol {
    var newsListSubject: PassthroughSubject<NewsFeedServiceModelResult, Never> { get }
    func fetchNewsFeed(pagination: Int)
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

    let newsListSubject = PassthroughSubject<NewsFeedServiceModelResult, Never>()
    
    func fetchNewsFeed(pagination: Int) {
        guard let request = endPoint.makeRequest(pagination)
        else {
            newsListSubject.send(.failure(.invalidRequest))
            return
        }
        networkService.genericDataTask(withRequest: request) { [weak self] result in
            switch result {
            case let .success((_, data)):
                do {
                    let newsFeed = try JSONDecoder().decode(News.self, from: data)
                    self?.newsListSubject.send(.success(newsFeed))
                } catch (_) {
                    self?.newsListSubject.send(.failure(.failedToParseNewsFeed))
                }
            case let .failure(error):
                let newsFeedError = NewsFeedServiceError(error: error as NSError)
                self?.newsListSubject.send(.failure(newsFeedError))
            }
        }
    }
}
