//
//  NewsListViewModelTests.swift
//  JBNewsFeedTests
//
//  Created by Jithin Balan on 31/8/21.
//

@testable import JBNewsFeed
import XCTest
import Nimble

class NewsListViewModelTests: XCTestCase {
    var viewModel: NewsListViewModel?
    private var display: NewsListDisplayMock!
    private var service: NewsFeedServiceMock!
    
    override func setUp() {
        super.setUp()
        display = NewsListDisplayMock()
        service = NewsFeedServiceMock()
        viewModel = NewsListViewModel(display: display, service: service)
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
    }
    
    func testNewsListViewModel_WithSuccess() {
        service.fetchNewsFeedCalled = true
        viewModel?.fetchNewsFeed(shouldShowIndicator: true)
        
        expect(self.viewModel?.numberOfRows()).to(equal(3))
        expect(self.viewModel?.title).to(equal("News Feed"))
        expect(self.viewModel?.item(at: IndexPath(row: 0, section: 0))).notTo(beNil())
        expect(self.viewModel?.item(at: IndexPath(row: 0, section: 0)).title).to(equal("title1"))
        expect(self.viewModel?.item(at: IndexPath(row: 0, section: 0)).author).to(equal("author1"))
        expect(self.viewModel?.item(at: IndexPath(row: 0, section: 0)).mediaPublishedDate).to(equal("29 Jan, 2021"))
        expect(self.viewModel?.item(at: IndexPath(row: 0, section: 0)).url).to(beAnInstanceOf(URL.self))
        
        expect(self.viewModel?.item(at: IndexPath(row: 1, section: 0)).title).to(equal("title2"))
        expect(self.viewModel?.item(at: IndexPath(row: 1, section: 0)).author).to(equal("author2"))
        expect(self.viewModel?.item(at: IndexPath(row: 1, section: 0)).mediaPublishedDate).to(equal("24 Jan, 2021"))
        expect(self.viewModel?.item(at: IndexPath(row: 1, section: 0)).url).to(beAnInstanceOf(URL.self))
    }
    
    func testNewsListViewModel_WithFailure() {
        service.fetchNewsFeedCalled = false
        viewModel?.fetchNewsFeed(shouldShowIndicator: true)
        
        expect(self.viewModel?.numberOfRows()).to(equal(0))
        expect(self.viewModel?.title).to(equal("News Feed"))
        expect(self.display.calledShowErrorAlert).to(beTrue())
    }
}

class NewsListDisplayMock: NewsListDisplay {
    var calledShowErrorAlert = false
    func showLoadingIndicator() {}
    func hideLoadingIndicator() {}
    func reloadDisplay() {}
    func showErrorAlert(_ viewModel: DisplayErrorAlertViewModel) {
        calledShowErrorAlert = true
    }
}

class NewsFeedServiceMock: NewsFeedServiceProtocol {
    var fetchNewsFeedCalled = true
    let news = News(totalPage: 100,
                    currentPage: 1,
                    articles: [Articles(title: "title1",
                                        author: "author1",
                                        publishedDate: "2021-08-29 04:45:00",
                                        excerpt: "short description",
                                        summary: "Summary",
                                        mediaUrl: "https://etimg.etb2bimg.com/image.jpg"),
                               Articles(title: "title2",
                                        author: "author2",
                                        publishedDate: "2021-08-24 16:51:00",
                                        excerpt: "short description",
                                        summary: "Summary",
                                        mediaUrl: "https://etimg.etb2bimg.com/image.jpg")])
    
    func fetchNewsFeed(pagination: Int, completion: @escaping NewsFeedServiceResult) {
        fetchNewsFeedCalled ? completion(.success(news)) : completion(.failure(.failedToFetchNewsFeed))
    }
}
