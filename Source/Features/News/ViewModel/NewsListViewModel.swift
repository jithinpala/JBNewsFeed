//
//  NewsListViewModel.swift
//  JBNewsFeed
//
//  Created by Jithin Balan on 30/8/21.
//

import Combine
import Foundation

enum NewsListDataStatus {
    case loading
    case finished
}

final class NewsListViewModel {
    private var articleViewModel = [ArticleViewModel]()
    private var subscriptions = Set<AnyCancellable>()
    var service: NewsFeedServiceProtocol
    let title = "News Feed"
    var paginationNumber: Int = 1
    
    let onDataLoad = PassthroughSubject<NewsListDataStatus, Never>()
    
    var shouldShowErrorAlert: Bool {
        articleViewModel.isEmpty
    }

    var errorAlertViewModel: DisplayErrorAlertViewModel {
        DisplayErrorAlertViewModel()
    }
    
    init(service: NewsFeedServiceProtocol = NewsFeedService()) {
        self.service = service
        setupBindings()
    }
    
    func viewDidLoad() {
        fetchNewsFeed(shouldShowIndicator: true)
    }
    
    func fetchNewsFeed(shouldShowIndicator: Bool) {
        if shouldShowIndicator {
            paginationNumber = 1
            onDataLoad.send(.loading)
        }
        service.fetchNewsFeed(pagination: paginationNumber)
    }

    private func setupBindings() {
        service.newsListSubject.receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(news):
                    let viewModels = news.articles?.map {
                        ArticleViewModel(article: $0)
                    } ?? []
                    
                    if viewModels.count > 0 {
                        viewModels.forEach {
                            self.articleViewModel.append($0)
                        }
                    }
                    self.paginationNumber = news.currentPage ?? 0
                case .failure:
                    print("Server error, need to handle")
                }
                self.onDataLoad.send(.finished)
            }.store(in: &subscriptions)
    }
    
    func loadMoreNewsFeed() {
        paginationNumber += 1
        service.fetchNewsFeed(pagination: paginationNumber)
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
