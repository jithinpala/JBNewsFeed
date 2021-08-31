//
//  NewsListViewModel.swift
//  JBNewsFeed
//
//  Created by Jithin Balan on 30/8/21.
//

import Foundation

protocol NewsListDisplay: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func reloadDisplay()
    func showErrorAlert(_ viewModel: DisplayErrorAlertViewModel)
}

final class NewsListViewModel {
    private var articleViewModel = [ArticleViewModel]()
    weak var display: NewsListDisplay?
    var service: NewsFeedServiceProtocol
    let title = "News Feed"
    var paginationNumber: Int = 1
    
    init(display: NewsListDisplay,
         service: NewsFeedServiceProtocol = NewsFeedService()) {
        self.display = display
        self.service = service
    }
    
    func viewDidLoad() {
        fetchNewsFeed(shouldShowIndicator: true)
    }
    
    func fetchNewsFeed(shouldShowIndicator: Bool) {
        if shouldShowIndicator {
            paginationNumber = 1
            display?.showLoadingIndicator()
        }
        service.fetchNewsFeed(pagination: paginationNumber) { [weak self] result in
            self?.display?.hideLoadingIndicator()
            switch result {
            case .success(let news):
                self?.articleViewModel = news.articles?.map {
                    ArticleViewModel(article: $0)
                } ?? []
                self?.paginationNumber = news.currentPage ?? 0
                self?.display?.reloadDisplay()
            case .failure(_):
                self?.display?.showErrorAlert(DisplayErrorAlertViewModel())
            }
        }
    }
    
    func loadMoreNewsFeed() {
        paginationNumber += 1
        service.fetchNewsFeed(pagination: paginationNumber) { [weak self] result in
            switch result {
            case .success(let news):
                let viewModels = news.articles?.map {
                    ArticleViewModel(article: $0)
                } ?? []
                if viewModels.count > 0 {
                    viewModels.forEach {
                        self?.articleViewModel.append($0)
                    }
                }
                self?.paginationNumber = news.currentPage ?? 0
                self?.display?.reloadDisplay()
            case .failure(_):
                self?.display?.showErrorAlert(DisplayErrorAlertViewModel())
            }
        }
    }
    
    func pullToRefreshDidTrigger() {
        fetchNewsFeed(shouldShowIndicator: false)
    }
    
    func numberOfSections() -> Int {
        1
    }
    
    func item(at indexPath: IndexPath) -> ArticleViewModel {
        articleViewModel[indexPath.row]
    }
    
    func numberOfRows() -> Int {
        articleViewModel.count > 0 ? articleViewModel.count + 1 : 0
    }
}
