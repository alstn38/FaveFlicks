//
//  SearchCollectionViewCell.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/28/25.
//

import Kingfisher
import SnapKit
import UIKit

final class SearchCollectionViewCell: UICollectionViewCell {
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(resource: .faveFlicksWhite)
        label.numberOfLines = 2
        return label
    }()
    
    private let movieDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(resource: .faveFlicksLightGray)
        label.numberOfLines = 1
        return label
    }()
    
    private let genreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        stackView.alignment = .leading
        return stackView
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
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .faveFlicksGray).withAlphaComponent(0.3)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        genreStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(_ detailMovie: DetailMovie) {
        movieTitleLabel.text = detailMovie.title
        movieDateLabel.text = detailMovie.releaseDate
        
        let url = URL(string: Secret.imageURL + detailMovie.posterPath)
        posterImageView.kf.setImage(with: url)
        
        configureGenreView(detailMovie.genreIDArray)
    }
    
    private func configureGenreView(_ genreIDArray: [Int]) {
        let maxCount = min(2, genreIDArray.count)
        
        for i in 0..<maxCount {
            let genreView = GenreView(genre: genreIDArray[i])
            genreStackView.addArrangedSubview(genreView)
        }
    }
    
    private func configureHierarchy() {
        addSubviews(
            posterImageView,
            movieTitleLabel,
            movieDateLabel,
            genreStackView,
            favoriteButton,
            lineView
        )
    }
    
    private func configureLayout() {
        posterImageView.snp.makeConstraints {
            $0.verticalEdges.leading.equalToSuperview().inset(15)
            $0.width.equalTo(80)
        }
        
        movieTitleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView).offset(4)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(15)
        }
        
        movieDateLabel.snp.makeConstraints {
            $0.top.equalTo(movieTitleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(12)
        }
        
        genreStackView.snp.makeConstraints {
            $0.bottom.equalTo(posterImageView.snp.bottom)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(12)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.trailing.bottom.equalToSuperview().inset(15)
        }
        
        lineView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.height.equalTo(1)
        }
    }
}
