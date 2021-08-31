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
    var service: NewsFeedServicesProtocol
    let title = "News Feed"
    
    init(display: NewsListDisplay,
         service: NewsFeedServicesProtocol = NewsFeedServices()) {
        self.display = display
        self.service = service
    }
    
    func viewDidLoad() {
        fetchNewsFeed(shouldShowIndicator: true)
    }
    
    func fetchNewsFeed(shouldShowIndicator: Bool) {
        if shouldShowIndicator {
            display?.showLoadingIndicator()
        }
        service.fetchNewsFeed { [weak self] result in
            self?.display?.hideLoadingIndicator()
            switch result {
            case .success(let news):
                self?.articleViewModel = news.articles?.map {
                    ArticleViewModel(article: $0)
                } ?? []
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
    
    func numberOfItems() -> Int {
        articleViewModel.count
    }
    
    func item(at indexPath: IndexPath) -> ArticleViewModel {
        articleViewModel[indexPath.row]
    }
}
