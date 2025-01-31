//
//  ProfileNickNameViewController.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/24/25.
//

import UIKit

final class ProfileNickNameViewController: UIViewController {
    
    private let presentationStyleType: PresentationStyleType
    private let profileNickNameView = ProfileNickNameView()
    private var nickNameStatus: ProfileNickNameView.NickNameStatus = .invalidRange
    private let profileImageManager = ProfileImageManager()
    
    private lazy var selectedProfileImageIndex: Int = {
        let selectedIndex = Int.random(in: 0..<profileImageManager.profileImageArray.count)
        return selectedIndex
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = StringLiterals.ProfileNickName.joinDateFormatter
        return formatter
    }()
    
    init(presentationStyleType: PresentationStyleType) {
        self.presentationStyleType = presentationStyleType
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = profileNickNameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureProfileImage()
        configureTapGestureRecognizer()
        configureTextField()
        configureButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func configureNavigation() {
        navigationItem.backButtonTitle = StringLiterals.NavigationItem.backButtonTitle
        
        switch presentationStyleType {
        case PresentationStyleType.push:
            navigationItem.title = StringLiterals.ProfileNickName.settingTitle
            
        case PresentationStyleType.modal:
            navigationItem.title = StringLiterals.ProfileNickName.editTitle
            let cancelButton = UIBarButtonItem(
                image: UIImage(systemName: "xmark"),
                style: .plain,
                target: self,
                action: #selector(cancelButtonDidTap)
            )
            
            let saveButton = UIBarButtonItem(
                title: StringLiterals.ProfileNickName.saveButtonTitle,
                style: .plain,
                target: self,
                action: #selector(saveButtonDidTap)
            )
            
            navigationItem.leftBarButtonItem = cancelButton
            navigationItem.rightBarButtonItem = saveButton
        }
    }
    
    private func configureProfileImage() {
        let image = profileImageManager.profileImageArray[selectedProfileImageIndex]
        profileNickNameView.configureView(image: image)
    }
    
    private func configureTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageViewDidTap))
        profileNickNameView.profileImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func configureTextField() {
        profileNickNameView.nickNameTextField.delegate = self
        profileNickNameView.nickNameTextField.addTarget(self, action: #selector(nickNameTextFieldDidEditingChange), for: .editingChanged)
    }
    
    private func configureButton() {
        switch presentationStyleType {
        case PresentationStyleType.push:
            profileNickNameView.confirmButton.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
            
        case PresentationStyleType.modal:
            profileNickNameView.confirmButton.isHidden = true
        }
    }
    
    private func saveUserInfo() {
        UserDefaultManager.shared.hasProfile = true
        UserDefaultManager.shared.profileImageIndex = selectedProfileImageIndex
        UserDefaultManager.shared.nickName = profileNickNameView.nickNameTextField.text ?? ""
        
        if presentationStyleType == .push {
            UserDefaultManager.shared.joinDate = dateFormatter.string(from: Date())
        }
        
        NotificationCenter.default.post(name: Notification.Name.updateUserInfo, object: nil)
    }
    
    @objc private func profileImageViewDidTap(_ sender: UIView) {
        let profileImageViewController = ProfileImageViewController(
            selectedProfileImageIndex: selectedProfileImageIndex,
            isEditMode: presentationStyleType == .modal
        )
        profileImageViewController.delegate = self
        navigationController?.pushViewController(profileImageViewController, animated: true)
    }
    
    @objc private func nickNameTextFieldDidEditingChange(_ sender: UITextField) {
        let sectionSignArray: [Character] = ["@", "#", "$", "%"]
        guard let inputNickName = sender.text else { return }
        guard !inputNickName.isEmpty else {
            nickNameStatus = .invalidRange
            return profileNickNameView.configureNickNameStatus(.empty)
        }
        
        guard inputNickName.count >= 2 && inputNickName.count < 10 else {
            nickNameStatus = .invalidRange
            return profileNickNameView.configureNickNameStatus(.invalidRange)
        }
        
        guard !inputNickName.contains(where: { sectionSignArray.contains($0) }) else {
            nickNameStatus = .hasSectionSign
            return profileNickNameView.configureNickNameStatus(.hasSectionSign)
        }
        
        guard !inputNickName.contains(where: { $0.isNumber }) else {
            nickNameStatus = .hasNumber
            return profileNickNameView.configureNickNameStatus(.hasNumber)
        }
        
        nickNameStatus = .possible
        profileNickNameView.configureNickNameStatus(.possible)
    }
    
    @objc private func confirmButtonDidTap(_ sender: UIButton) {
        guard nickNameStatus == .possible else {
            return presentAlert(title: StringLiterals.Alert.invalidNickName, message: nickNameStatus.description)
        }
        
        saveUserInfo()
        
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first
        else { return }
        
        let faveFlicksTabBarController = FaveFlicksTabBarController()
        faveFlicksTabBarController.view.alpha = 0.5
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear) {
            faveFlicksTabBarController.view.alpha = 1.0
        }
        
        window.rootViewController = faveFlicksTabBarController
    }
    
    @objc private func cancelButtonDidTap(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonDidTap(_ sender: UIBarButtonItem) {
        guard nickNameStatus == .possible else {
            return presentAlert(title: StringLiterals.Alert.invalidNickName, message: nickNameStatus.description)
        }
        
        saveUserInfo()
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension ProfileNickNameViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

// MARK: - ProfileImageViewControllerDelegate
extension ProfileNickNameViewController: ProfileImageViewControllerDelegate {
    
    func viewController(_ viewController: UIViewController, didSelectImageIndex: Int) {
        selectedProfileImageIndex = didSelectImageIndex
        configureProfileImage()
    }
}

// MARK: - PresentationStyle
extension ProfileNickNameViewController {
    
    enum PresentationStyleType {
        case push
        case modal
    }
}
