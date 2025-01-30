//
//  CastCollectionViewCell.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/29/25.
//

import Kingfisher
import SnapKit
import UIKit

final class CastCollectionViewCell: UICollectionViewCell {
    
    private let actorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let actorKoreanNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = UIColor(resource: .faveFlicksWhite)
        label.numberOfLines = 1
        return label
    }()
    
    private let actorCharacterNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor(resource: .faveFlicksGray)
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(_ cast: Cast) {
        if let profilePath = cast.profilePath {
            let url = URL(string: Secret.imageURL + profilePath)
            actorImageView.kf.setImage(with: url)
        } else {
            actorImageView.image = UIImage(resource: .splash)
        }
        
        actorKoreanNameLabel.text = cast.name
        actorCharacterNameLabel.text = cast.character
    }
    
    private func configureHierarchy() {
        addSubviews(
            actorImageView,
            actorKoreanNameLabel,
            actorCharacterNameLabel
        )
    }
    
    private func configureLayout() {
        actorImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(5)
            $0.size.equalTo(50)
        }
        
        actorKoreanNameLabel.snp.makeConstraints {
            $0.bottom.equalTo(actorImageView.snp.centerY).offset(-2)
            $0.leading.equalTo(actorImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(12)
        }
        
        actorCharacterNameLabel.snp.makeConstraints {
            $0.top.equalTo(actorImageView.snp.centerY).offset(2)
            $0.leading.equalTo(actorImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(12)
        }
    }
}
