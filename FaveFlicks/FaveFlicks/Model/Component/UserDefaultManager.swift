//
//  UserDefaultManager.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/25/25.
//

import Foundation

final class UserDefaultManager {
    
    static let shared = UserDefaultManager()
    
    private init() { }
    
    private static let hasProfileKey: String = "hasProfileKey"
    
    @UserDefault(key: hasProfileKey, defaultValue: false)
    var hasProfile
}
