//
//  ProfileImageViewController.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/24/25.
//

import UIKit

final class ProfileImageViewController: UIViewController {
    
    private let profileImageView = ProfileImageView()
    private let profileImageArray: [UIImage] = [
        .profile0, .profile1, .profile2, .profile3, .profile4, .profile5, .profile6, .profile7,.profile8,.profile9,.profile10,.profile11
    ]

    override func loadView() {
        view = profileImageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureCollectionView()
    }
    
    private func configureNavigation() {
        navigationItem.title = StringLiterals.ProfileImage.title
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
        return profileImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileImageCollectionViewCell.identifier,
            for: indexPath
        ) as? ProfileImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureView(profileImageArray[indexPath.item])
        
        return cell
    }
}
