//
//  MovieImageEndPoint.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/29/25.
//

import Alamofire
import Foundation

enum MovieImageEndPoint: EndPointProtocol {
    case movie(movieID: Int)
}

extension MovieImageEndPoint {
    
    var url: URL? {
        return URL(string: baseURL + path)
    }
    
    var baseURL: String {
        return Secret.baseURL
    }
    
    var path: String {
        switch self {
        case .movie(let movieID):
            return "/movie/\(movieID)/images"
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
            return nil
        }
    }
}
