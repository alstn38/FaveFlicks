//
//  UserDefaultManager.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/25/25.
//

import UIKit

final class UserDefaultManager {
    
    static let shared = UserDefaultManager()
    
    private init() { }
    
    private static let hasProfileKey: String = "hasProfileKey"
    private static let profileImageIndexKey: String = "profileImageIndexKey"
    private static let nickNameKey: String = "nickNameKey"
    private static let joinDateKey: String = "joinDateKey"
    private static let movieBoxCountKey: String = "movieBoxCountKey"
    private static let recentSearchedTextArrayKey: String = "recentSearchedTextArrayKey"
    
    @UserDefault(key: hasProfileKey, defaultValue: false)
    var hasProfile
    
    @UserDefault(key: profileImageIndexKey, defaultValue: 0)
    var profileImageIndex
    
    @UserDefault(key: nickNameKey, defaultValue: "")
    var nickName
    
    @UserDefault(key: joinDateKey, defaultValue: "")
    var joinDate
    
    @UserDefault(key: movieBoxCountKey, defaultValue: 0)
    var movieBoxCount
    
    @UserDefault(key: recentSearchedTextArrayKey, defaultValue: Array<String>())
    var recentSearchedTextArray
    
    func deleteAccount() {
        hasProfile = false
        profileImageIndex = 0
        nickName = ""
        joinDate = ""
        movieBoxCount = 0
    }
}
