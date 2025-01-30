//
//  CreditEndPoint.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/30/25.
//

import Alamofire
import Foundation

enum CreditEndPoint: EndPointProtocol {
    case movie(movieID: Int)
}

extension CreditEndPoint {
    
    var url: URL? {
        return URL(string: baseURL + path)
    }
    
    var baseURL: String {
        return Secret.baseURL
    }
    
    var path: String {
        switch self {
        case .movie(let movieID):
            return "/movie/\(movieID)/credits"
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
            ]
        }
    }
}
