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
    
    init(article: Articles) {
        self.title = article.title
        self.author = article.author
        self.publishedDate = article.publishedDate
        self.excerpt = article.excerpt
        self.summary = article.summary
        self.mediaUrl = article.mediaUrl
    }
}
