//
//  SearchMovie.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/28/25.
//

import Foundation

struct SearchMovie: Codable {
    let page: Int
    let results: [DetailMovie]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
