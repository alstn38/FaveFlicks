//
//  EndPointProtocol.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/27/25.
//

import Alamofire
import Foundation

protocol EndPointProtocol {
    var url: URL? { get }
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
}
