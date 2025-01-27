//
//  NetworkError.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/27/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case verificationFailed
    case unauthorized
    case forbidden
    case notFound
    case invalidRequest
    case invalidParameters
    case tooManyRequests
    case serverError
    case invalidService
    case badGateway
    case serviceOffline
    case timeOut
    case decodeError
    case unowned
    
    var description: String {
        switch self {
        case .invalidURL:
            return "잘못된 URL 형식입니다."
        case .verificationFailed:
            return "검증에 실패했습니다."
        case .unauthorized:
            return "인증 실패: 서비스에 액세스할 수 있는 권한이 없습니다."
        case .forbidden:
            return "중복된 항목: 제출하려는 데이터가 이미 있습니다."
        case .notFound:
            return "잘못된 ID: 필수 ID가 잘못되었거나 찾을 수 없습니다."
        case .invalidRequest:
            return "잘못된 형식입니다. 이 서비스는 해당 형식으로 존재하지 않습니다."
        case .invalidParameters:
            return "잘못된 매개변수: 요청 매개변수가 올바르지 않습니다."
        case .tooManyRequests:
            return "요청 수가 허용 한도를 초과했습니다."
        case .serverError:
            return "내부 오류: 오류가 발생했습니다. TMDB에 문의하세요."
        case .invalidService:
            return "잘못된 서비스: 이 서비스는 존재하지 않습니다."
        case .badGateway:
            return "백엔드 서버에 연결할 수 없습니다."
        case .serviceOffline:
            return "서비스 오프라인: 이 서비스는 현재 오프라인 상태입니다. 나중에 다시 시도하세요."
        case .timeOut:
            return "백엔드 서버에 대한 요청 시간이 초과되었습니다. 다시 시도하세요."
        case .decodeError:
            return "Decoding Error"
        case .unowned:
            return "Unowned Error"
        }
    }
}
