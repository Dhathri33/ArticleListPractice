//
//  DateOnly.swift
//  ArticleListPractice
//
//  Created by Dhathri Bathini on 10/13/25.
//

import Foundation

struct ArticleDetails: Decodable, Hashable {
    let author: String?
    let description: String?
    let urlToImage: String?
    let publishedAt: String?
}

struct ArticleList: Decodable {
    let status: String
    let totalResults: Int
    let articles: [ArticleDetails]
}
