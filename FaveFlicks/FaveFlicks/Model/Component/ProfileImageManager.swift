//
//  ProfileImageManager.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/27/25.
//

import UIKit

final class ProfileImageManager {
    
    private let profileImageArray: [UIImage] = [
        .profile0, .profile1, .profile2, .profile3, .profile4, .profile5, .profile6, .profile7,.profile8,.profile9,.profile10,.profile11
    ]
    
    var profileImageCount: Int {
        return profileImageArray.count
    }
    
    func getCurrentProfileImage() -> UIImage {
        let currentImageIndex = UserDefaultManager.shared.profileImageIndex
        return profileImageArray[currentImageIndex]
    }
    
    func getProfileImage(at index: Int) -> UIImage? {
        guard index >= 0 && index < profileImageArray.count else { return nil }
        return profileImageArray[index]
    }
}
