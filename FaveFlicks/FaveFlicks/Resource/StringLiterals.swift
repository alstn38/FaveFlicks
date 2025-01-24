//
//  StringLiterals.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/24/25.
//

import Foundation

enum StringLiterals {
    
    enum NavigationItem {
        static let backButtonTitle: String = ""
    }
    
    enum Onboarding {
        static let title: String = "Onboarding"
        static let subTitle: String = "당신만의 영화 세상,\nFavaFlicks를 시작해보세요."
        static let startButtonTitle: String = "시작하기"
    }
    
    enum ProfileNickName {
        static let title: String = "프로필 설정"
        static let nickNamePlaceholder: String = "닉네임을 입력해주세요."
        static let confirmButtonTitle: String = "완료"
        static let possibleStatus: String = "사용할 수 있는 닉네임이에요"
        static let invalidRangeStatus: String = "2글자 이상 10글자 미만으로 설정해주세요"
        static let hasSectionSignStatus: String = "낙내암애 @, #, $, %는 포함할 수 없어요"
        static let hasNumberStatus: String = "닉네임에 숫자는 포함할 수 없어요"
    }
}
