//
//  Secret.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/27/25.
//

import Foundation

enum Secret {
    static let baseURL: String = {
        guard let urlString = Bundle.main.infoDictionary?["BASE_URL"] as? String else {
            fatalError("BASE_URL ERROR")
        }
        return urlString
    }()
    
    static let accessToken: String = {
        guard let accessToken = Bundle.main.infoDictionary?["ACCESS_TOKEN"] as? String else {
            fatalError("ACCESS_TOKEN ERROR")
        }
        return accessToken
    }()
    
    static let imageURL: String = {
        guard let urlString = Bundle.main.infoDictionary?["IMAGE_URL"] as? String else {
            fatalError("IMAGE_URL ERROR")
        }
        return urlString
    }()
}
