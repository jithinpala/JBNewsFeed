//
//  NewsListViewController.swift
//  JBNewsFeed
//
//  Created by Jithin Balan on 30/8/21.
//

import UIKit

class NewsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewsListDisplay {
    
    private let tableView = UITableView()
    private var refreshControl: UIRefreshControl!
    private lazy var viewModel = NewsListViewModel(display: self)
    
    private var activityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
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
    
    private func setupView() {
        title = viewModel.title
        view.addSubview(tableView)
        view.addSubview(activityIndicatorView)
        
        activityIndicatorView.style = .gray
        if #available(iOS 13.0, *) {
            activityIndicatorView.style = .large
        }
        activityIndicatorView.hidesWhenStopped = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(fromClass: NewsListViewCell.self)
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
    }
    
    func hideLoadingIndicator() {
        activityIndicatorView.stopAnimating()
    }
    
    func reloadDisplay() {
        tableView.reloadData()
        if refreshControl.isRefreshing {
            stopPullToRefresh()
        }
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
        viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(NewsListViewCell.self, for: indexPath)
        let articleViewModel = viewModel.item(at: indexPath)
        cell.configure(articleViewModel)
        return cell
    }
}
