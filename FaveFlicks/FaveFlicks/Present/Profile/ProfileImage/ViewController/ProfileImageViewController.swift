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
    
    private let profileImageView = ProfileImageView()
    private var selectedProfileImageIndex: Int
    private let profileImageManager = ProfileImageManager()
    weak var delegate: ProfileImageViewControllerDelegate?

    override func loadView() {
        view = profileImageView
    }
    
    init(selectedProfileImageIndex: Int) {
        self.selectedProfileImageIndex = selectedProfileImageIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureProfileImage()
        configureCollectionView()
    }
    
    private func configureNavigation() {
        navigationItem.title = StringLiterals.ProfileImage.title
    }
    
    private func configureProfileImage() {
        let image = profileImageManager.profileImageArray[selectedProfileImageIndex]
        profileImageView.configureView(image: image)
    }
    
    private func configureCollectionView() {
        profileImageView.profileImageCollectionView.delegate = self
        profileImageView.profileImageCollectionView.dataSource = self
        profileImageView.profileImageCollectionView.register(
            ProfileImageCollectionViewCell.self,
            forCellWithReuseIdentifier: ProfileImageCollectionViewCell.identifier
        )
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ProfileImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileImageManager.profileImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileImageCollectionViewCell.identifier,
            for: indexPath
        ) as? ProfileImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureView(profileImageManager.profileImageArray[indexPath.item])
        
        if indexPath.item == selectedProfileImageIndex {
            cell.configureView(isSelected: true)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let deSelectedCell = collectionView.cellForItem(
            at: IndexPath(item: selectedProfileImageIndex, section: 0)
        ) as? ProfileImageCollectionViewCell else { return }
        deSelectedCell.configureView(isSelected: false)
        
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? ProfileImageCollectionViewCell else { return }
        selectedCell.configureView(isSelected: true)
        selectedProfileImageIndex = indexPath.item
        
        configureProfileImage()
        delegate?.viewController(self, didSelectImageIndex: selectedProfileImageIndex)
    }
}
