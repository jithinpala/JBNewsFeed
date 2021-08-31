//
//  LoadMoreViewCell.swift
//  JBNewsFeed
//
//  Created by Jithin Balan on 31/8/21.
//

import UIKit

class LoadMoreViewCell: UITableViewCell {

    private lazy var titleLabel: UILabel = {
        var title = UILabel()
        title.numberOfLines = 1
        title.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private var activityIndicatorView = UIActivityIndicatorView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        activityIndicatorView.style = .gray
        contentView.addSubview(titleLabel)
        contentView.addSubview(activityIndicatorView)
        
        setupConstraint()
    }
    
    private func setupConstraint() {
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        activityIndicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    func configure() {
        titleLabel.text = "Loading..."
        activityIndicatorView.startAnimating()
    }

}
