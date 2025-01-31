//
//  NotificationName+.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/30/25.
//

import Foundation

extension Notification.Name {
    
    static let updateUserInfo = Notification.Name("updateUserInfo")
    static let updateRecentSearchTextArray = Notification.Name("updateRecentSearchTextArray")
    static let updateFavoriteMovieDictionary = Notification.Name("updateFavoriteMovieDictionary")
}
