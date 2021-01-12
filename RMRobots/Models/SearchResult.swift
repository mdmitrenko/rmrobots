//
//  SearchResult.swift
//  RMRobots
//
//  Created by Maksim Dmitrenko on 11.01.2021.
//

import Foundation

struct SearchResult: Codable {
    let total: Int
    let totalPages: Int
    let results: [Image]
    
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case total, results
    }
}
