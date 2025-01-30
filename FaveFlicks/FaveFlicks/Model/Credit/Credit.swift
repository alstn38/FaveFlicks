//
//  Credit.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/30/25.
//

import Foundation

struct Credit: Codable {
    let id: Int
    let cast: [Cast]
}

struct Cast: Codable {
    let name: String
    let character: String?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case name
        case profilePath = "profile_path"
        case character
    }
}
