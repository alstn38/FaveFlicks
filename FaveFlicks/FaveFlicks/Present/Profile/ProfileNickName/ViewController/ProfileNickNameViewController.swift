//
//  ProfileNickNameViewController.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/24/25.
//

import UIKit

final class ProfileNickNameViewController: UIViewController {
    
    private let profileNickNameView = ProfileNickNameView()
    
    private let profileImageArray: [UIImage] = [
        .profile0, .profile1, .profile2, .profile3, .profile4, .profile5, .profile6, .profile7,.profile8,.profile9,.profile10,.profile11
    ]
    
    private lazy var selectedProfileImageIndex: Int = {
        let selectedIndex = Int.random(in: 0..<profileImageArray.count)
        return selectedIndex
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func configureNavigation() {
        navigationItem.title = StringLiterals.ProfileNickName.title
        navigationItem.backButtonTitle = StringLiterals.NavigationItem.backButtonTitle
    }
    
    private func configureProfileImage() {
        let image = profileImageArray[selectedProfileImageIndex]
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
    
    @objc private func profileImageViewDidTap(_ sender: UIView) {
        let profileImageViewController = ProfileImageViewController(
            selectedProfileImageIndex: selectedProfileImageIndex,
            profileImageArray: profileImageArray
        )
        profileImageViewController.delegate = self
        navigationController?.pushViewController(profileImageViewController, animated: true)
    }
    
    @objc private func nickNameTextFieldDidEditingChange(_ sender: UITextField) {
        let sectionSignArray: [Character] = ["@", "#", "$", "%"]
        guard let inputNickName = sender.text else { return }
        guard !inputNickName.isEmpty else {
            return profileNickNameView.configureNickNameStatus(.empty)
        }
        
        guard inputNickName.count >= 2 && inputNickName.count < 10 else {
            return profileNickNameView.configureNickNameStatus(.invalidRange)
        }
        
        guard !inputNickName.contains(where: { sectionSignArray.contains($0) }) else {
            return profileNickNameView.configureNickNameStatus(.hasSectionSign)
        }
        
        guard !inputNickName.contains(where: { $0.isNumber }) else {
            return profileNickNameView.configureNickNameStatus(.hasNumber)
        }
        
        profileNickNameView.configureNickNameStatus(.possible)
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
