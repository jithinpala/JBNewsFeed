//
//  ArticleViewModel.swift
//  JBNewsFeed
//
//  Created by Jithin Balan on 31/8/21.
//

import Foundation

struct ArticleViewModel {
    let title: String?
    let author: String?
    let publishedDate: String?
    let excerpt: String?
    let summary: String?
    let mediaUrl: String?
    
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD HH:mm:ss"
        return formatter
    }()
    
    private static let shortFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, yyyy"
        return formatter
    }()
    
    init(article: Articles) {
        self.title = article.title
        self.author = article.author
        self.publishedDate = article.publishedDate
        self.excerpt = article.excerpt
        self.summary = article.summary
        self.mediaUrl = article.mediaUrl
    }
    
    var url: URL? {
        guard let mediaUrl = mediaUrl,
              let url = URL(string: mediaUrl)
        else { return nil }
        return url
    }
    
    var mediaPublishedDate: String? {
        guard let publishedDate = publishedDate,
              let dateValue = ArticleViewModel.formatter.date(from: publishedDate)
        else { return nil }
        return ArticleViewModel.shortFormatter.string(from: dateValue)
    }
}
