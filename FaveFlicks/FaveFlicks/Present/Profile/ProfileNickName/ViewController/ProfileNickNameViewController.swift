//
//  ProfileNickNameViewController.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/24/25.
//

import UIKit

final class ProfileNickNameViewController: UIViewController {
    
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
        navigationItem.title = StringLiterals.ProfileNickName.title
        navigationItem.backButtonTitle = StringLiterals.NavigationItem.backButtonTitle
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
        profileNickNameView.confirmButton.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
    }
    
    @objc private func profileImageViewDidTap(_ sender: UIView) {
        let profileImageViewController = ProfileImageViewController(selectedProfileImageIndex: selectedProfileImageIndex)
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
        
        UserDefaultManager.shared.hasProfile = true
        UserDefaultManager.shared.profileImageIndex = selectedProfileImageIndex
        print("NickName = \(profileNickNameView.nickNameTextField.text ?? "")")
        print("joinDate = \(dateFormatter.string(from: Date()))")
        UserDefaultManager.shared.nickName = profileNickNameView.nickNameTextField.text ?? ""
        UserDefaultManager.shared.joinDate = dateFormatter.string(from: Date())
        let faveFlicksTabBarController = FaveFlicksTabBarController()
        
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first
        else { return }
        
        faveFlicksTabBarController.view.alpha = 0.5
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear) {
            faveFlicksTabBarController.view.alpha = 1.0
        }
        
        window.rootViewController = faveFlicksTabBarController
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
