//
//  ProfileNickNameViewModel.swift
//  FaveFlicks
//
//  Created by 강민수 on 2/7/25.
//

import Foundation

final class ProfileNickNameViewModel {
    
    struct Input {
        let profileImageViewDidTap: PublishSubject<Void>
        let profileImageDidChange: PublishSubject<Int>
        let nickNameTextFieldEditingChange: PublishSubject<String?>
        let mbtiButtonDidTap: PublishSubject<ProfileNickNameView.MBTIButtonType>
        let confirmButtonDidTap: PublishSubject<Void>
    }
    
    struct Output {
        let profileImage: BehaviorSubject<Int>
        let nickNameStatusText: PublishSubject<String?>
        let mbtiButtonStatus: PublishSubject<(ProfileNickNameView.MBTIButtonType, Bool)>
        let confirmButtonStatus: BehaviorSubject<Bool>
        let moveToOtherViewController: PublishSubject<PresentationStyleType>
    }
    
    let presentationStyleType: PresentationStyleType
    
    init(presentationStyleType: PresentationStyleType) {
        self.presentationStyleType = presentationStyleType
    }
    
    func transform(from input: Input) -> Output {
        
    }
}

// MARK: - PresentationStyleType
extension ProfileNickNameViewModel {
    
    enum PresentationStyleType {
        case push
        case modal
    }
}
