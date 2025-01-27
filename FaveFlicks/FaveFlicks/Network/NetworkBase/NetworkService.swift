//
//  NetworkService.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/27/25.
//

import Alamofire

final class NetworkService {
    
    static let shared = NetworkService()
    
    private init() { }
    
    func request<T: Decodable>(
        endPoint: EndPointProtocol,
        responseType: T.Type,
        completionHandler: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = endPoint.url else {
            return completionHandler(.failure(.invalidURL))
        }
        
        AF.request(
            url,
            method: endPoint.method,
            parameters: endPoint.parameters,
            headers: endPoint.headers
        )
        .validate(statusCode: 200...299)
        .responseDecodable(of: T.self) { [weak self] response in
            guard let self else { return }
            switch response.result {
            case .success(let value):
                completionHandler(.success(value))
            case .failure(let error):
                let errorType = self.getNetworkError(error)
                completionHandler(.failure(errorType))
            }
        }
    }
    
    private func getNetworkError(_ error: AFError) -> NetworkError {
        if error.underlyingError is DecodingError {
            return .decodeError
        }
        
        switch error.responseCode {
        case 400: return .verificationFailed
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 405: return .invalidRequest
        case 422: return .invalidParameters
        case 429: return .tooManyRequests
        case 500: return .serverError
        case 501: return .invalidService
        case 502: return .badGateway
        case 503: return .serviceOffline
        case 504: return .timeOut
        default: return .unowned
        }
    }
}
