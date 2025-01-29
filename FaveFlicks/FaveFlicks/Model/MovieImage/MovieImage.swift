//
//  MovieImage.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/29/25.
//

import Foundation

struct MovieImage: Codable {
    let id: Int
    let backdrops: [DetailImage]
    let posters: [DetailImage]
}

// MARK: - Backdrop
struct DetailImage: Codable {
    let filePath: String

    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
}
