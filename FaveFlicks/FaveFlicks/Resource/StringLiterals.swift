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
    
    enum TapBar {
        static let cinemaTitle: String = "CINEMA"
        static let upComingTitle: String = "UPCOMING"
        static let settingTitle: String = "PROFILE"
    }
    
    enum Alert {
        static let invalidNickName: String = "닉네임이 조건에 맞지 않습니다"
        static let confirm: String = "확인"
        static let cancel: String = "취소"
        static let networkError: String = "네트워크 오류"
    }
    
    enum Onboarding {
        static let title: String = "Onboarding"
        static let subTitle: String = "당신만의 영화 세상,\nFavaFlicks를 시작해보세요."
        static let startButtonTitle: String = "시작하기"
    }
    
    enum ProfileNickName {
        static let settingTitle: String = "프로필 설정"
        static let editTitle: String = "프로필 편집"
        static let saveButtonTitle: String = "저장"
        static let nickNamePlaceholder: String = "닉네임을 입력해주세요."
        static let confirmButtonTitle: String = "완료"
        static let possibleStatus: String = "사용할 수 있는 닉네임이에요"
        static let invalidRangeStatus: String = "2글자 이상 10글자 미만으로 설정해주세요"
        static let hasSectionSignStatus: String = "닉네임에 @, #, $, %는 포함할 수 없어요"
        static let hasNumberStatus: String = "닉네임에 숫자는 포함할 수 없어요"
        static let joinDateFormatter: String = "yy.MM.dd 가입"
    }
    
    enum ProfileImage {
        static let settingTitle: String = "프로필 이미지 설정"
        static let editTitle: String = "프로필 이미지 편집"
    }
    
    enum Cinema {
        static let title: String = "오늘의 영화"
        static let movieBoxCount: String = "개의 무비박스 보관중"
        static let recentSearchedTitle: String = "최근검색어"
        static let recentSearchedDelete: String = "전체 삭제"
        static let noRecentSearchedGuide: String = "최근 검색어 내역이 없습니다."
        static let todayMovieTitle: String = "오늘의 영화"
        static let emptyOverview: String = "영화 줄거리 정보가 없습니다."
    }
    
    enum Search {
        static let title: String = "영화 검색"
        static let searchPlaceholder: String = "영화를 검색해보세요."
        static let noResultText: String = "원하는 검색결과를 찾지 못했습니다."
        static let serverDateFormatter: String = "yyyy-MM-dd"
        static let presentDateFormatter: String = "yyyy. MM. dd"
        static let noServerDate: String = "개봉일 정보가 없습니다."
    }
    
    enum DetailMovie {
        static let synopsisTitle: String = "Synopsis"
        static let moreButtonTitle: String = "More"
        static let hideButtonTitle: String = "Hide"
        static let castTitle: String = "Cast"
        static let posterTitle: String = "Poster"
        static let comma: String = ","
        static let backdropGuideText: String = "영화 관련 사진이 없습니다."
        static let castGuideText: String = "영화 등장인물 정보가 없습니다."
        static let posterGuideText: String = "영화 포스터 정보가 없습니다."
        static let emptySynopsis: String = "영화 줄거리 정보가 없습니다."
        static let noGenreText: String = "장르없음"
    }
    
    enum Setting {
        static let title: String = "설정"
        static let frequentlyAskedQuestions: String = "자주 묻는 질문"
        static let oneOnoneInquiry: String = "1:1 문의"
        static let setNotifications: String = "알림 설정"
        static let deleteAccount: String = "탈퇴하기"
        static let deleteAlertTitle: String = "탈퇴하기"
        static let deleteAlertMessage: String = "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?"
    }
    
    enum UpComing {
        static let title: String = "UPCOMING"
        static let upComingGuideText: String = "강민수"
    }
}
