//
//  ProfileNickNameViewController.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/24/25.
//

import UIKit

final class ProfileNickNameViewController: UIViewController {
    
    private let profileNickNameView = ProfileNickNameView()

    override func loadView() {
        view = profileNickNameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
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
    
    private func configureTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageViewDidTap))
        profileNickNameView.profileImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func configureTextField() {
        profileNickNameView.nickNameTextField.delegate = self
        profileNickNameView.nickNameTextField.addTarget(self, action: #selector(nickNameTextFieldDidEditingChange), for: .editingChanged)
    }
    
    @objc private func profileImageViewDidTap(_ sender: UIView) {
        let profileImageViewController = ProfileImageViewController()
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
