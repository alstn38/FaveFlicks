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
    private static let profileImageKey: String = "userProfileKey"
    private static let nickNameKey: String = "nickNameKey"
    private static let joinDateKey: String = "joinDateKey"
    private static let movieBoxCountKey: String = "movieBoxCountKey"
    
    @UserDefault(key: profileImageKey, defaultValue: false)
    var hasProfile
    
    @UserDefault(key: profileImageKey, defaultValue: UIImage(resource: .profile0))
    var profileImage
    
    @UserDefault(key: nickNameKey, defaultValue: "")
    var nickName
    
    @UserDefault(key: joinDateKey, defaultValue: "")
    var joinDate
    
    @UserDefault(key: movieBoxCountKey, defaultValue: 0)
    var movieBoxCount
}
