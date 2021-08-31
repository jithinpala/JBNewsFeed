//
//  News.swift
//  JBNewsFeed
//
//  Created by Jithin Balan on 31/8/21.
//

import Foundation

struct News: Decodable {
    let totalPage: Int
    let currentPage: Int
    let articles: [Articles]
    
    enum CodingKeys: String, CodingKey {
        case totalPage = "total_pages"
        case currentPage = "page"
        case articles
    }
}
