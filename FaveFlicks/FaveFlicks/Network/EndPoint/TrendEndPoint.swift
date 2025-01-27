//
//  TrendMovieEndPoint.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/27/25.
//

import Alamofire
import Foundation

enum TrendEndPoint: EndPointProtocol {
    case movie
}

extension TrendEndPoint {
    
    var url: URL? {
        return URL(string: baseURL + path)
    }
    
    var baseURL: String {
        return Secret.baseURL
    }
    
    var path: String {
        switch self {
        case .movie:
            return "/day"
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
        case .movie:
            return [
                "language": "ko-KR",
                "page": "1"
            ]
        }
    }
}
