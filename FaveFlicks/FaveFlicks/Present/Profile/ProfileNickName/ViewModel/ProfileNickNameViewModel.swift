//
//  ProfileNickNameViewModel.swift
//  FaveFlicks
//
//  Created by 강민수 on 2/7/25.
//

import Foundation

final class ProfileNickNameViewModel: InputOutputModel {
    
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
    
    let presentationStyleType: PresentationStyleType
    let profileImageManager = ProfileImageManager()
    private var currentImageIndex: Int = 0
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
        let output = Output(
            profileImageIndex: CurrentValueRelay(0),
            nickNameStatusText: CurrentValueRelay(.empty),
            mbtiButtonStatus: CurrentValueRelay((.extraversion, false)),
            confirmButtonStatus: BehaviorSubject(false),
            moveToOtherViewController: CurrentValueRelay(.dismiss)
        )
        
        input.viewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            switch presentationStyleType {
            case .push:
                currentImageIndex = profileImageManager.randomImageIndex
                output.profileImageIndex.send(profileImageManager.randomImageIndex)
            case .modal:
                currentImageIndex = UserDefaultManager.shared.profileImageIndex
                output.profileImageIndex.send(UserDefaultManager.shared.profileImageIndex)
            }
        }
        
        input.profileImageViewDidTap.bind { [weak self] _ in
            guard let self else { return }
            output.moveToOtherViewController.send(.pushProfileImageViewController(currentImageIndex))
        }
        
        input.profileImageDidChange.bind { [weak self] imageIndex in
            guard let self else { return }
            currentImageIndex = imageIndex
            output.profileImageIndex.send(imageIndex)
        }
        
        input.nickNameTextFieldEditingChange.bind { [weak self] text in
            guard let self else { return }
            currentNickNameText = text
            let nickNameStatus = validateNickName(text)
            if nickNameStatus == .possible {
                isPossibleNickName = true
            }
            output.nickNameStatusText.send(nickNameStatus)
            
            let isValidationConfirmButton = isValidateConfirmButton()
            output.confirmButtonStatus.send(isValidationConfirmButton)
        }
        
        input.mbtiButtonDidTap.bind { [weak self] buttonType in
            guard let self else { return }
            validateMBTIButton(buttonType, mbtiButtonStatusSubject: output.mbtiButtonStatus)
            let isValidationConfirmButton = isValidateConfirmButton()
            output.confirmButtonStatus.send(isValidationConfirmButton)
        }
        
        input.confirmButtonDidTap.bind { [weak self] _ in
            guard let self else { return }
            saveUserInfo()
            
            switch presentationStyleType {
            case .push:
                output.moveToOtherViewController.send(.changeRootView)
            case .modal:
                output.moveToOtherViewController.send(.dismiss)
            }
        }
        
        return output
    }
    
    private func validateNickName(_ nickName: String?) -> NickNameStatus {
        guard let nickName else { return .empty }
        let sectionSignArray: [Character] = ["@", "#", "$", "%"]
        
        guard !nickName.isEmpty else {
            isPossibleNickName = false
            return .empty
        }
        
        guard nickName.count >= 2 && nickName.count < 10 else {
            isPossibleNickName = false
            return .invalidRange
        }
        
        guard !nickName.contains(where: { sectionSignArray.contains($0) }) else {
            isPossibleNickName = false
            return .hasSectionSign
        }
        
        guard !nickName.contains(where: { $0.isNumber }) else {
            isPossibleNickName = false
            return .hasNumber
        }
        
        return .possible
    }
    
    private func validateMBTIButton(
        _ type: ProfileNickNameView.MBTIButtonType,
        mbtiButtonStatusSubject: CurrentValueRelay<(ProfileNickNameView.MBTIButtonType, Bool)>
    ) {
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
    
    private func isValidateConfirmButton() -> Bool {
        guard
            isPossibleNickName,
            userMBTITypeDictionary[0] is ProfileNickNameView.MBTIButtonType,
            userMBTITypeDictionary[1] is ProfileNickNameView.MBTIButtonType,
            userMBTITypeDictionary[2] is ProfileNickNameView.MBTIButtonType,
            userMBTITypeDictionary[3] is ProfileNickNameView.MBTIButtonType
        else {
            return false
        }
        
        return true
    }
    
    private func saveUserInfo() {
        UserDefaultManager.shared.hasProfile = true
        UserDefaultManager.shared.profileImageIndex = currentImageIndex
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
