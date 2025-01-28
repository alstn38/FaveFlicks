//
//  SearchEndPoint.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/28/25.
//

import Alamofire
import Foundation

enum SearchEndPoint: EndPointProtocol {
    case movie(query: String, page: Int)
}

extension SearchEndPoint {
    
    var url: URL? {
        return URL(string: baseURL + path)
    }
    
    var baseURL: String {
        return Secret.baseURL
    }
    
    var path: String {
        switch self {
        case .movie:
            return "/search/movie"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .movie:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        return ["Authorization": Secret.accessToken]
    }
    
    var parameters: Parameters? {
        switch self {
        case .movie(let query, let page):
            return [
                "query": query,
                "include_adult": false,
                "language": "ko-KR",
                "page": page
            ]
        }
    }
}
