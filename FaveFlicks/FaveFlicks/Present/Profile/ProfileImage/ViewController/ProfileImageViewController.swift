//
//  ProfileImageViewController.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/24/25.
//

import UIKit

protocol ProfileImageViewControllerDelegate: AnyObject {
    func viewController(_ viewController: UIViewController, didSelectImageIndex: Int)
}

final class ProfileImageViewController: UIViewController {
    
    private let viewModel: ProfileImageViewModel
    private let input: ProfileImageViewModel.Input
    private let profileImageView = ProfileImageView()
    weak var delegate: ProfileImageViewControllerDelegate?

    override func loadView() {
        view = profileImageView
    }
    
    init(viewModel: ProfileImageViewModel) {
        self.viewModel = viewModel
        self.input = ProfileImageViewModel.Input(profileImageDidSelect: CurrentValueRelay(0))
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBind()
        configureNavigation()
        configureCollectionView()
    }
    
    private func configureBind() {
        let output = viewModel.transform(from: input)
        
        output.profileImageIndex.bind { [weak self] past, current in
            guard let self else { return }
            configureProfileImageCell(at: past, isSelected: false)
            configureProfileImageCell(at: current, isSelected: true)
            configureProfileImage(at: current)
        }
    }
    
    private func configureNavigation() {
        let title = viewModel.isEditMode
        ? StringLiterals.ProfileImage.editTitle
        : StringLiterals.ProfileImage.settingTitle
        navigationItem.title = title
    }
    
    private func configureCollectionView() {
        profileImageView.profileImageCollectionView.delegate = self
        profileImageView.profileImageCollectionView.dataSource = self
        profileImageView.profileImageCollectionView.register(
            ProfileImageCollectionViewCell.self,
            forCellWithReuseIdentifier: ProfileImageCollectionViewCell.identifier
        )
    }
    
    private func configureProfileImage(at imageIndex: Int) {
        let image = viewModel.profileImageManager.getProfileImage(at: imageIndex)
        profileImageView.configureView(image: image)
    }
    
    private func configureProfileImageCell(at imageIndex: Int, isSelected: Bool) {
        DispatchQueue.main.async {
            guard let cell = self.profileImageView.profileImageCollectionView.cellForItem(
                at: IndexPath(item: imageIndex, section: 0)
            ) as? ProfileImageCollectionViewCell else { return }
            
            cell.configureView(isSelected: isSelected)
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ProfileImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.profileImageManager.profileImageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileImageCollectionViewCell.identifier,
            for: indexPath
        ) as? ProfileImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureView(viewModel.profileImageManager.getProfileImage(at: indexPath.item))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        input.profileImageDidSelect.send(indexPath.item)
        delegate?.viewController(self, didSelectImageIndex: indexPath.item)
    }
}
