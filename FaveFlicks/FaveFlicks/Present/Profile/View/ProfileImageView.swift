//
//  ProfileImageView.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/24/25.
//

import SnapKit
import UIKit

final class ProfileImageView: UIView {
    
    private let profileImageView = ProfileView(size: 100)
    
    private let profileImageButton: UIButton = {
        var imageConfiguration = UIImage.SymbolConfiguration(pointSize: 10)
        var configuration = UIButton.Configuration.filled()
        configuration.preferredSymbolConfigurationForImage = imageConfiguration
        configuration.image = UIImage(systemName: "camera.fill")
        configuration.baseBackgroundColor = UIColor(resource: .faveFlicsMain)
        configuration.baseForegroundColor = UIColor(resource: .faveFlicksWhite)
        
        let button = UIButton(configuration: configuration)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()
    
    let profileImageCollectionView: UICollectionView = {
        let cellCountOfRow = 4
        let insetSize: CGFloat = 20
        let minimumSpacing: CGFloat = 15
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let possibleCellLength: CGFloat = screenWidth - (insetSize * 2) - (minimumSpacing * (CGFloat(cellCountOfRow) - 1))
        let cellLength: CGFloat = possibleCellLength / CGFloat(cellCountOfRow)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = minimumSpacing
        layout.minimumLineSpacing = minimumSpacing
        layout.itemSize = CGSize(width: cellLength, height: cellLength)
        layout.sectionInset = UIEdgeInsets(top: insetSize, left: insetSize, bottom: insetSize, right: insetSize)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(resource: .faveFlicksBlack)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = UIColor(resource: .faveFlicksBlack)
    }
    
    private func configureHierarchy() {
        addSubviews(
            profileImageView,
            profileImageButton,
            profileImageCollectionView
        )
    }
    
    private func configureLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        profileImageButton.snp.makeConstraints {
            $0.bottom.trailing.equalTo(profileImageView)
            $0.size.equalTo(30)
        }
        
        profileImageCollectionView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(40)
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
