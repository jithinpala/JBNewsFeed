//
//  NewsListViewCell.swift
//  JBNewsFeed
//
//  Created by Jithin Balan on 30/8/21.
//

import UIKit

class NewsListViewCell: UITableViewCell {
    
    private lazy var mediaImage: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        var title = UILabel()
        title.numberOfLines = 2
        title.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var authorLabel: UILabel = {
        var title = UILabel()
        title.numberOfLines = 1
        title.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var publishedDateLabel: UILabel = {
        var title = UILabel()
        title.numberOfLines = 1
        title.font = UIFont.systemFont(ofSize: 14, weight: .light)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var summaryLabel: UILabel = {
        var title = UILabel()
        title.numberOfLines = 6
        title.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var bottomDivider: UIView = {
        var divider = UIView()
        divider.backgroundColor = UIColor(named: "dividerColor")
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(mediaImage)
        contentView.addSubview(bottomDivider)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(publishedDateLabel)
        contentView.addSubview(summaryLabel)
        
        setupConstraint()
    }
    
    private func setupConstraint() {
        mediaImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        mediaImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        mediaImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        mediaImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: mediaImage.trailingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        authorLabel.leadingAnchor.constraint(equalTo: mediaImage.trailingAnchor, constant: 10).isActive = true
        authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        authorLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        publishedDateLabel.leadingAnchor.constraint(equalTo: mediaImage.trailingAnchor, constant: 10).isActive = true
        publishedDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        publishedDateLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 5).isActive = true
        publishedDateLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        summaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        summaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        summaryLabel.topAnchor.constraint(equalTo: publishedDateLabel.bottomAnchor, constant: 10).isActive = true
        
        bottomDivider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        bottomDivider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        bottomDivider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bottomDivider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        summaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
    }
    
    func configure(_ viewModel: ArticleViewModel) {
        self.selectionStyle = .none
        titleLabel.text = viewModel.title
        authorLabel.text = viewModel.author
        publishedDateLabel.text = viewModel.mediaPublishedDate
        summaryLabel.text = viewModel.summary
        
        let placeHolderImage = UIImage(named: "newsPlaceHolder")
        guard let url = viewModel.url
        else {
            mediaImage.image = placeHolderImage
            return
        }
        mediaImage.setImageURL(url, placeholderImage: placeHolderImage)
    }

}
