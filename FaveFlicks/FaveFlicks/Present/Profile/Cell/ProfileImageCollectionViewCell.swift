//
//  ProfileImageCollectionViewCell.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/24/25.
//

import SnapKit
import UIKit

final class ProfileImageCollectionViewCell: UICollectionViewCell {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor(resource: .faveFlicksLightGray).cgColor
        imageView.alpha = 0.5
        imageView.layer.masksToBounds = true
        return imageView
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
    
    func configureView(_ image: UIImage) {
        profileImageView.image = image
    }
    
    func configureView(isSelected: Bool) {
        let alpha: CGFloat = isSelected ? 1.0 : 0.5
        let borderWidth: CGFloat = isSelected ? 3.0 : 1.0
        let borderColor: CGColor = isSelected
        ? UIColor(resource: .faveFlicsMain).cgColor
        : UIColor(resource: .faveFlicksLightGray).cgColor
        
        profileImageView.alpha = alpha
        profileImageView.layer.borderWidth = borderWidth
        profileImageView.layer.borderColor = borderColor
    }
    
    private func configureView() {
        profileImageView.layer.cornerRadius = self.frame.height / 2
    }
    
    private func configureHierarchy() {
        addSubview(profileImageView)
    }
    
    private func configureLayout() {
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
