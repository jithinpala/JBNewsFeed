//
//  NewsFeedServiceTests.swift
//  JBNewsFeedTests
//
//  Created by Jithin Balan on 31/8/21.
//

@testable import JBNewsFeed
import XCTest
import Nimble

class NewsFeedServiceTests: XCTestCase {
    
    var service: NewsFeedServicesMock?
    
    override func setUp() {
        super.setUp()
        service = NewsFeedServicesMock()
    }
    
    override func tearDown() {
        super.tearDown()
        service = nil
    }
    
    func testNewsFeedService_FetchNewsFeed_SuccessWithSingleArticle() {
        service?.response = MockResponse().singleNews
        expect(self.service?.fetchNewsFeedCalled).to(beFalse())
        
        service?.fetchNewsFeed(pagination: 1, completion: { result in
            switch result {
            case .success(let news):
                expect(self.service?.response).notTo(beNil())
                expect(news).notTo(beNil())
                expect(news.totalPage).to(equal(100))
                expect(news.currentPage).to(equal(1))
                expect(news.articles?.count).to(equal(1))
            case .failure(let error):
                fail("NewsFeedServices failed unexpectedly with error \(error)")
            }
        })
        expect(self.service?.fetchNewsFeedCalled).toEventually(beTrue())
    }
    
    func testNewsFeedService_FetchNewsFeed_SuccessWithMultipleArticle() {
        service?.response = MockResponse().multipleNews
        expect(self.service?.fetchNewsFeedCalled).to(beFalse())
        
        service?.fetchNewsFeed(pagination: 1, completion: { result in
            switch result {
            case .success(let news):
                expect(self.service?.response).notTo(beNil())
                expect(news).notTo(beNil())
                expect(news.totalPage).to(equal(100))
                expect(news.currentPage).to(equal(1))
                expect(news.articles?.count).to(equal(3))
            case .failure(let error):
                fail("NewsFeedServices failed unexpectedly with error \(error)")
            }
        })
        expect(self.service?.fetchNewsFeedCalled).toEventually(beTrue())
    }
    
    func testNewsFeedService_FetchNewsFeed_WithFailure() {
        service?.response = nil
        expect(self.service?.fetchNewsFeedCalled).to(beFalse())
        service?.fetchNewsFeed(pagination: 1, completion: { result in
            switch result {
            case .success(_):
                fail("NewsFeedService should return error")
            case .failure(let error):
                expect(error).notTo(beNil())
            }
        })
        expect(self.service?.fetchNewsFeedCalled).toEventually(beTrue())
    }
}

private struct MockResponse {
    var singleNews: Data? {
        return """
        {
            "status": "ok",
            "total_hits": 10000,
            "page": 1,
            "total_pages": 100,
            "page_size": 50,
            "articles": [
              {
                "title": "title",
                "author": "Author",
                "published_date": "2021-08-29 04:45:00",
                "excerpt": "Short description",
                "summary": "After electric vehicles",
                "media": "https://demoUrl/image.jpg"
              }
            ]
          }
        """.data(using: .utf8)
    }
    
    var multipleNews: Data? {
        return """
        {
            "status": "ok",
            "total_hits": 10000,
            "page": 1,
            "total_pages": 100,
            "page_size": 50,
            "articles": [
              {
                "title": "title",
                "author": "Author",
                "published_date": "2021-08-29 04:45:00",
                "excerpt": "Short description",
                "summary": "After electric vehicles",
                "media": "https://demoUrl/image.jpg"
              },
              {
                "title": "title",
                "author": "Author",
                "published_date": "2021-08-29 04:45:00",
                "excerpt": "Short description",
                "summary": "After electric vehicles",
                "media": "https://demoUrl/image.jpg"
              },
              {
                "title": "title",
                "author": "Author",
                "published_date": "2021-08-29 04:45:00",
                "excerpt": "Short description",
                "summary": "After electric vehicles",
                "media": "https://demoUrl/image.jpg"
              }
            ]
          }
        """.data(using: .utf8)
    }
}

class NewsFeedServicesMock: NewsFeedServiceProtocol {
    var fetchNewsFeedCalled = false
    var response: Data?
    
    func fetchNewsFeed(pagination: Int, completion: @escaping NewsFeedServiceResult) {
        fetchNewsFeedCalled = true
        if let response = response {
            do {
                let newsFeed = try JSONDecoder().decode(News.self, from: response)
                completion(.success(newsFeed))
            } catch(_) {
                completion(.failure(.failedToParseNewsFeed))
            }
        } else {
            completion(.failure(.failedToFetchNewsFeed))
        }
    }
}
