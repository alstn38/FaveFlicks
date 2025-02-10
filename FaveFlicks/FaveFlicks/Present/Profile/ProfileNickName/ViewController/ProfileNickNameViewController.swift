//
//  ProfileNickNameViewController.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/24/25.
//

import UIKit

final class ProfileNickNameViewController: UIViewController {
    
    private let viewModel: ProfileNickNameViewModel
    private let input: ProfileNickNameViewModel.Input
    private let profileNickNameView = ProfileNickNameView()
    
    init(viewModel: ProfileNickNameViewModel) {
        self.viewModel = viewModel
        self.input = ProfileNickNameViewModel.Input(
            viewDidLoad: CurrentValueRelay(()),
            profileImageViewDidTap: CurrentValueRelay(()),
            profileImageDidChange: CurrentValueRelay(0),
            nickNameTextFieldEditingChange: CurrentValueRelay(nil),
            mbtiButtonDidTap: CurrentValueRelay(.extraversion),
            confirmButtonDidTap: CurrentValueRelay(())
        )
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
        
        configureBind()
        configureNavigation()
        configureProfileNickName()
        configureTapGestureRecognizer()
        configureTextField()
        configureButton()
        input.viewDidLoad.send(())
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func configureBind() {
        let output = viewModel.transform(from: input)
        
        output.profileImageIndex.bind { [weak self] index in
            guard let self else { return }
            let profileImage = viewModel.profileImageManager.getProfileImage(at: index)
            profileNickNameView.configureView(image: profileImage)
        }
        
        output.nickNameStatusText.bind { [weak self] status in
            guard let self else { return }
            profileNickNameView.configureNickNameStatus(status)
        }
        
        output.mbtiButtonStatus.bind { [weak self] (mbtiButtonType, activate) in
            guard let self else { return }
            profileNickNameView.configureMBTIButton(mbtiButtonType, activate: activate)
        }
        
        output.confirmButtonStatus.bind { [weak self] status in
            guard let self else { return }
            profileNickNameView.configureConfirmButton(status)
        }
        
        output.moveToOtherViewController.bind { [weak self] screenTransitionType in
            guard let self else { return }
            switch screenTransitionType {
            case .changeRootView:
                changeRootView()
                
            case .dismiss:
                dismiss(animated: true)
                
            case .pushProfileImageViewController(let imageIndex):
                let isEditMode = viewModel.presentationStyleType == .modal ? true : false
                let profileImageViewModel = ProfileImageViewModel(
                    selectedProfileImageIndex: imageIndex,
                    isEditMode: isEditMode
                )
                let profileImageViewController = ProfileImageViewController(viewModel: profileImageViewModel)
                profileImageViewController.delegate = self
                navigationController?.pushViewController(profileImageViewController, animated: true)
            }
        }
    }
    
    private func configureNavigation() {
        navigationItem.backButtonTitle = StringLiterals.NavigationItem.backButtonTitle
        
        switch viewModel.presentationStyleType {
        case .push:
            navigationItem.title = StringLiterals.ProfileNickName.settingTitle
            
        case .modal:
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
    
    private func configureProfileNickName() {
        if viewModel.presentationStyleType == .modal {
            profileNickNameView.nickNameTextField.text = UserDefaultManager.shared.nickName
            nickNameTextFieldDidEditingChange(profileNickNameView.nickNameTextField)
        }
    }
    
    private func configureTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageViewDidTap))
        profileNickNameView.profileImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func configureTextField() {
        profileNickNameView.nickNameTextField.delegate = self
        profileNickNameView.nickNameTextField.addTarget(
            self,
            action: #selector(nickNameTextFieldDidEditingChange),
            for: .editingChanged
        )
    }
    
    private func configureButton() {
        switch viewModel.presentationStyleType {
        case .push:
            profileNickNameView.confirmButton.addTarget(
                self,
                action: #selector(confirmButtonDidTap),
                for: .touchUpInside
            )
            
        case .modal:
            profileNickNameView.confirmButton.isHidden = true
        }
        
        profileNickNameView.extraversionButton.addTarget(self, action: #selector(mbtiButtonDidTap), for: .touchUpInside)
        profileNickNameView.introversionButton.addTarget(self, action: #selector(mbtiButtonDidTap), for: .touchUpInside)
        profileNickNameView.sensingButton.addTarget(self, action: #selector(mbtiButtonDidTap), for: .touchUpInside)
        profileNickNameView.intuitionButton.addTarget(self, action: #selector(mbtiButtonDidTap), for: .touchUpInside)
        profileNickNameView.thinkingButton.addTarget(self, action: #selector(mbtiButtonDidTap), for: .touchUpInside)
        profileNickNameView.feelingButton.addTarget(self, action: #selector(mbtiButtonDidTap), for: .touchUpInside)
        profileNickNameView.judgingButton.addTarget(self, action: #selector(mbtiButtonDidTap), for: .touchUpInside)
        profileNickNameView.perceivingButton.addTarget(self, action: #selector(mbtiButtonDidTap), for: .touchUpInside)
    }
    
    private func changeRootView() {
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
    
    @objc private func profileImageViewDidTap(_ sender: UIView) {
        input.profileImageViewDidTap.send(())
    }
    
    @objc private func nickNameTextFieldDidEditingChange(_ sender: UITextField) {
        input.nickNameTextFieldEditingChange.send(sender.text)
    }
    
    @objc private func mbtiButtonDidTap(_ sender: UIButton) {
        guard let buttonType = ProfileNickNameView.MBTIButtonType(rawValue: sender.tag) else { return }
        input.mbtiButtonDidTap.send(buttonType)
    }
    
    @objc private func confirmButtonDidTap(_ sender: UIButton) {
        input.confirmButtonDidTap.send(())
    }
    
    @objc private func cancelButtonDidTap(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonDidTap(_ sender: UIBarButtonItem) {
        input.confirmButtonDidTap.send(())
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
        input.profileImageDidChange.send(didSelectImageIndex)
    }
}
