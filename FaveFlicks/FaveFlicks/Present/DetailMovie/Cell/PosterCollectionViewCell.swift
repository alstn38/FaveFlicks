//
//  PosterCollectionViewCell.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/29/25.
//

import Kingfisher
import SnapKit
import UIKit

final class PosterCollectionViewCell: UICollectionViewCell {
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = UIColor(resource: .faveFlicksWhite)
        return activityIndicatorView
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
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
    
    func configureCell(_ detailImage: DetailImage) {
        let url = URL(string: Secret.imageURL + detailImage.filePath)
        activityIndicatorView.startAnimating()
        posterImageView.kf.setImage(with: url) { [weak self] _ in
            self?.activityIndicatorView.stopAnimating()
        }
    }
    
    private func configureHierarchy() {
        addSubviews(
            posterImageView,
            activityIndicatorView
        )
    }
    
    private func configureLayout() {
        activityIndicatorView.snp.makeConstraints {
            $0.center.equalTo(posterImageView)
        }
        
        posterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
