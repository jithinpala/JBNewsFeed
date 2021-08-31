//
//  Articles.swift
//  JBNewsFeed
//
//  Created by Jithin Balan on 31/8/21.
//

import Foundation

struct Articles: Decodable {
    let title: String?
    let author: String?
    let publishedDate: String?
    let excerpt: String?
    let summary: String?
    let mediaUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case author
        case publishedDate = "published_date"
        case excerpt
        case summary
        case mediaUrl
    }
}
