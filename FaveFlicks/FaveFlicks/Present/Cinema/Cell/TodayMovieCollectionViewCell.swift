//
//  TodayMovieCollectionViewCell.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/27/25.
//

import Kingfisher
import SnapKit
import UIKit

final class TodayMovieCollectionViewCell: UICollectionViewCell {
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(resource: .faveFlicksWhite)
        label.numberOfLines = 1
        return label
    }()
    
    private let favoriteButton: UIButton = {
        var imageConfiguration = UIImage.SymbolConfiguration(pointSize: 18)
        var configuration = UIButton.Configuration.plain()
        configuration.preferredSymbolConfigurationForImage = imageConfiguration
        configuration.baseForegroundColor = UIColor(resource: .faveFlicsMain)
        
        let button = UIButton(configuration: configuration)
        button.setImage(
            UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(weight: .medium)),
            for: .normal
        )
        button.setImage(
            UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .medium)),
            for: .selected
        )
        return button
    }()
    
    private let movieDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = UIColor(resource: .faveFlicksLightGray)
        label.numberOfLines = 2
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
    
    func configureCell(_ trendMovie: DetailMovie) {
        movieTitleLabel.text = trendMovie.title
        movieDescriptionLabel.text = trendMovie.overview
        
        let url = URL(string: Secret.imageURL + trendMovie.posterPath)
        posterImageView.kf.setImage(with: url)
    }
    
    private func configureHierarchy() {
        addSubviews(
            posterImageView,
            movieTitleLabel,
            favoriteButton,
            movieDescriptionLabel
        )
    }
    
    private func configureLayout() {
        posterImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.greaterThanOrEqualTo(100)
        }
        
        movieTitleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.height.equalTo(17)
            $0.trailing.equalTo(favoriteButton.snp.leading).offset(-10)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.centerY.equalTo(movieTitleLabel)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        movieDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(movieTitleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.height.lessThanOrEqualTo(28)
            $0.bottom.equalToSuperview().inset(5)
        }
    }
}
