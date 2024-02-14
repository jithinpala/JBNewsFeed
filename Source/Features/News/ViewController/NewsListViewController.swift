//
//  NewsListViewController.swift
//  JBNewsFeed
//
//  Created by Jithin Balan on 30/8/21.
//

import Combine
import UIKit

class NewsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private let viewModel: NewsListViewModel
    private var refreshControl: UIRefreshControl!
    private var activityIndicatorView = UIActivityIndicatorView()
    private var subscriptions = Set<AnyCancellable>()

    init(viewModel: NewsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "primaryBackgroundColor")
        setupView()
        
        setupBindings()
        viewModel.viewDidLoad()
        addRefreshController()
    }
    
    private func addRefreshController() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefreshDidTrigger), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func pullToRefreshDidTrigger() {
        viewModel.pullToRefreshDidTrigger()
    }

    private func setupBindings() {
        viewModel.onDataLoad.sink { [weak self] status in
            if status == .loading {
                self?.showLoadingIndicator()
            } else {
                self?.hideLoadingIndicator()
                self?.reloadDisplay()
            }
        }.store(in: &subscriptions)
    }
    
    private func setupView() {
        title = viewModel.title
        view.addSubview(tableView)
        view.addSubview(activityIndicatorView)
        
        activityIndicatorView.style = .gray
        activityIndicatorView.style = .large
        activityIndicatorView.hidesWhenStopped = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(fromClass: NewsListViewCell.self)
        tableView.register(fromClass: LoadMoreViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        setupTableViewConstraint()
    }
    
    private func setupTableViewConstraint() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    // MARK: - NewsListDisplay
    
    func showLoadingIndicator() {
        activityIndicatorView.startAnimating()
        tableView.isHidden = true
    }
    
    func hideLoadingIndicator() {
        tableView.isHidden = false
        activityIndicatorView.stopAnimating()
    }
    
    func reloadDisplay() {
        if refreshControl.isRefreshing {
            stopPullToRefresh()
        }
        if viewModel.shouldShowErrorAlert {
            showErrorAlert(viewModel.errorAlertViewModel)
            return
        }
        tableView.reloadData()
    }
    
    func stopPullToRefresh() {
        refreshControl.endRefreshing()
    }
    
    func showErrorAlert(_ viewModel: DisplayErrorAlertViewModel) {
        let alert = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: viewModel.buttonTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLastRow(indexPath) {
            let cell = tableView.dequeue(LoadMoreViewCell.self, for: indexPath)
            cell.configure()
            return cell
        }
        
        let cell = tableView.dequeue(NewsListViewCell.self, for: indexPath)
        let articleViewModel = viewModel.item(at: indexPath)
        cell.configure(articleViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isLastRow(indexPath) {
            viewModel.loadMoreNewsFeed()
        }
    }
    
    private func isLastRow(_ indexPath: IndexPath) -> Bool {
        let lastElement = viewModel.numberOfRows() - 1
        if indexPath.row == lastElement && lastElement > 0 {
            return true
        }
        return false
    }
}
