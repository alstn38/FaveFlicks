//
//  ProfileNickNameViewModel.swift
//  FaveFlicks
//
//  Created by 강민수 on 2/7/25.
//

import Foundation

final class ProfileNickNameViewModel {
    
    struct Input {
        let viewDidLoad: CurrentValueRelay<Void>
        let profileImageViewDidTap: CurrentValueRelay<Void>
        let profileImageDidChange: CurrentValueRelay<Int>
        let nickNameTextFieldEditingChange: CurrentValueRelay<String?>
        let mbtiButtonDidTap: CurrentValueRelay<ProfileNickNameView.MBTIButtonType>
        let confirmButtonDidTap: CurrentValueRelay<Void>
    }
    
    struct Output {
        let profileImageIndex: CurrentValueRelay<Int>
        let nickNameStatusText: CurrentValueRelay<NickNameStatus>
        let mbtiButtonStatus: CurrentValueRelay<(ProfileNickNameView.MBTIButtonType, Bool)>
        let confirmButtonStatus: BehaviorSubject<Bool>
        let moveToOtherViewController: CurrentValueRelay<screenTransitionType>
    }
    
    private let profileImageIndexSubject: CurrentValueRelay<Int> = CurrentValueRelay(0)
    private let nickNameStatusTextSubject: CurrentValueRelay<NickNameStatus> = CurrentValueRelay(.empty)
    private let mbtiButtonStatusSubject: CurrentValueRelay<(ProfileNickNameView.MBTIButtonType, Bool)> = CurrentValueRelay((.extraversion, false))
    private let confirmButtonStatusSubject: BehaviorSubject<Bool> = BehaviorSubject(false)
    private let moveToOtherViewControllerSubject: CurrentValueRelay<screenTransitionType> = CurrentValueRelay(.dismiss)
    
    let presentationStyleType: PresentationStyleType
    let profileImageManager = ProfileImageManager()
    private var currentNickNameText: String?
    private var isPossibleNickName: Bool = false
    private var userMBTITypeDictionary: [Int: ProfileNickNameView.MBTIButtonType?] = [:]
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = StringLiterals.ProfileNickName.joinDateFormatter
        return formatter
    }()
    
    init(presentationStyleType: PresentationStyleType) {
        self.presentationStyleType = presentationStyleType
    }
    
    func transform(from input: Input) -> Output {
        input.viewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            switch presentationStyleType {
            case .push:
                profileImageIndexSubject.send(profileImageManager.randomImageIndex)
            case .modal:
                profileImageIndexSubject.send(UserDefaultManager.shared.profileImageIndex)
            }
        }
        
        input.profileImageViewDidTap.bind { [weak self] _ in
            guard let self else { return }
            moveToOtherViewControllerSubject.send(.pushProfileImageViewController(profileImageIndexSubject.value))
        }
        
        input.profileImageDidChange.bind { [weak self] imageIndex in
            guard let self else { return }
            profileImageIndexSubject.send(imageIndex)
        }
        
        input.nickNameTextFieldEditingChange.bind { [weak self] text in
            guard let self else { return }
            currentNickNameText = text
            validateNickName(text)
            validateConfirmButton()
        }
        
        input.mbtiButtonDidTap.bind { [weak self] buttonType in
            guard let self else { return }
            validateMBTIButton(buttonType)
            validateConfirmButton()
        }
        
        input.confirmButtonDidTap.bind { [weak self] _ in
            guard let self else { return }
            saveUserInfo()
            
            switch presentationStyleType {
            case .push:
                moveToOtherViewControllerSubject.send(.changeRootView)
            case .modal:
                moveToOtherViewControllerSubject.send(.dismiss)
            }
        }
        
        return Output(
            profileImageIndex: profileImageIndexSubject,
            nickNameStatusText: nickNameStatusTextSubject,
            mbtiButtonStatus: mbtiButtonStatusSubject,
            confirmButtonStatus: confirmButtonStatusSubject,
            moveToOtherViewController: moveToOtherViewControllerSubject
        )
    }
    
    private func validateNickName(_ nickName: String?) {
        guard let nickName else { return }
        let sectionSignArray: [Character] = ["@", "#", "$", "%"]
        
        guard !nickName.isEmpty else {
            isPossibleNickName = false
            nickNameStatusTextSubject.send(.empty)
            return
        }
        
        guard nickName.count >= 2 && nickName.count < 10 else {
            isPossibleNickName = false
            nickNameStatusTextSubject.send(.invalidRange)
            return
        }
        
        guard !nickName.contains(where: { sectionSignArray.contains($0) }) else {
            isPossibleNickName = false
            nickNameStatusTextSubject.send(.hasSectionSign)
            return
        }
        
        guard !nickName.contains(where: { $0.isNumber }) else {
            isPossibleNickName = false
            nickNameStatusTextSubject.send(.hasNumber)
            return
        }
        
        nickNameStatusTextSubject.send(.possible)
        isPossibleNickName = true
    }
    
    private func validateMBTIButton(_ type: ProfileNickNameView.MBTIButtonType) {
        let mbtiSection = type.rawValue / 2
        guard let userMBTIType = userMBTITypeDictionary[mbtiSection] as? ProfileNickNameView.MBTIButtonType else {
            userMBTITypeDictionary[mbtiSection] = type
            mbtiButtonStatusSubject.send((type, true))
            return
        }
        
        let oppositeType = type.rawValue.isMultiple(of: 2)
        ? ProfileNickNameView.MBTIButtonType(rawValue: type.rawValue + 1) ?? type
        : ProfileNickNameView.MBTIButtonType(rawValue: type.rawValue - 1) ?? type
        mbtiButtonStatusSubject.send((oppositeType, false))
        mbtiButtonStatusSubject.send((type, userMBTIType != type))
        userMBTITypeDictionary[mbtiSection] = userMBTIType != type ? type: nil
    }
    
    private func validateConfirmButton() {
        guard
            isPossibleNickName,
            userMBTITypeDictionary[0] is ProfileNickNameView.MBTIButtonType,
            userMBTITypeDictionary[1] is ProfileNickNameView.MBTIButtonType,
            userMBTITypeDictionary[2] is ProfileNickNameView.MBTIButtonType,
            userMBTITypeDictionary[3] is ProfileNickNameView.MBTIButtonType
        else {
            return confirmButtonStatusSubject.send(false)
        }
        confirmButtonStatusSubject.send(true)
    }
    
    private func saveUserInfo() {
        UserDefaultManager.shared.hasProfile = true
        UserDefaultManager.shared.profileImageIndex = profileImageIndexSubject.value
        UserDefaultManager.shared.nickName = currentNickNameText ?? ""
        
        if presentationStyleType == .push {
            UserDefaultManager.shared.joinDate = dateFormatter.string(from: Date())
        }
        
        let userMBTI = getUserMBTI()
        UserDefaultManager.shared.userMBTI = userMBTI
        
        NotificationCenter.default.post(name: Notification.Name.updateUserInfo, object: nil)
    }
    
    private func getUserMBTI() -> String {
        guard
            let energyFocus = userMBTITypeDictionary[0] as? ProfileNickNameView.MBTIButtonType,
            let perceivingFunction = userMBTITypeDictionary[1] as? ProfileNickNameView.MBTIButtonType,
            let judgingFunction = userMBTITypeDictionary[2] as? ProfileNickNameView.MBTIButtonType,
            let lifestylePreference = userMBTITypeDictionary[3] as? ProfileNickNameView.MBTIButtonType
        else { return "" }
        
        let userMBTI = energyFocus.description
        + perceivingFunction.description
        + judgingFunction.description
        + lifestylePreference.description
        
        return userMBTI
    }
}

// MARK: - PresentationStyleType
extension ProfileNickNameViewModel {
    
    enum PresentationStyleType {
        case push
        case modal
    }
    
    enum screenTransitionType {
        case changeRootView
        case dismiss
        case pushProfileImageViewController(Int)
    }
}

// MARK: - NickNameStatus
extension ProfileNickNameViewModel {
    
    enum NickNameStatus {
        case empty
        case possible
        case invalidRange
        case hasSectionSign
        case hasNumber
        
        var description: String {
            switch self {
            case .empty:
                return ""
            case .possible:
                return StringLiterals.ProfileNickName.possibleStatus
            case .invalidRange:
                return StringLiterals.ProfileNickName.invalidRangeStatus
            case .hasSectionSign:
                return StringLiterals.ProfileNickName.hasSectionSignStatus
            case .hasNumber:
                return StringLiterals.ProfileNickName.hasNumberStatus
            }
        }
    }
}
