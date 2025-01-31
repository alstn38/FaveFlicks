//
//  DetailMovieView.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/29/25.
//

import SnapKit
import UIKit

final class DetailMovieView: UIView {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let backdropCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width: CGFloat = UIScreen.main.bounds.width
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = .zero
        layout.minimumLineSpacing = .zero
        layout.sectionInset = .zero
        layout.itemSize = CGSize(width: width, height: width * 9 / 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(resource: .faveFlicksBlack)
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    let backdropPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = false
        pageControl.backgroundColor = UIColor(resource: .faveFlicksBlack).withAlphaComponent(0.3)
        pageControl.layer.cornerRadius = 10
        return pageControl
    }()
    
    private let movieInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private let calendarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = UIColor(resource: .faveFlicksGray)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let calendarDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(resource: .faveFlicksGray)
        return label
    }()
    
    private let firstVerticalView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .faveFlicksGray)
        return view
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = UIColor(resource: .faveFlicksGray)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let starRateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(resource: .faveFlicksGray)
        return label
    }()
    
    private let secondVerticalView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .faveFlicksGray)
        return view
    }()
    
    private let filmImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "film.fill")
        imageView.tintColor = UIColor(resource: .faveFlicksGray)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(resource: .faveFlicksGray)
        return label
    }()
    
    private let synopsisTitleLabel: UILabel = {
        let label = UILabel()
        label.text = StringLiterals.DetailMovie.synopsisTitle
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(resource: .faveFlicksWhite)
        return label
    }()
    
    let moreHideButton: UIButton = {
        let button = UIButton()
        button.setTitle(StringLiterals.DetailMovie.moreButtonTitle, for: .normal)
        button.setTitle(StringLiterals.DetailMovie.hideButtonTitle, for: .selected)
        button.setTitleColor(UIColor(resource: .faveFlicsMain), for: .normal)
        button.setTitleColor(UIColor(resource: .faveFlicksGray), for: .highlighted)
        button.setTitleColor(UIColor(resource: .faveFlicsMain), for: .selected)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        return button
    }()
    
    let synopsisDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(resource: .faveFlicksWhite)
        label.numberOfLines = 3
        return label
    }()
    
    private let castTitleLabel: UILabel = {
        let label = UILabel()
        label.text = StringLiterals.DetailMovie.castTitle
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(resource: .faveFlicksWhite)
        return label
    }()
    
    let castCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width: CGFloat = UIScreen.main.bounds.width
        let edgeInset: CGFloat = 10
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = edgeInset
        layout.sectionInset = UIEdgeInsets(top: 0, left: edgeInset, bottom: 0, right: edgeInset)
        layout.itemSize = CGSize(width: width * 2 / 5, height: 60)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(resource: .faveFlicksBlack)
        return collectionView
    }()
    
    private let posterTitleLabel: UILabel = {
        let label = UILabel()
        label.text = StringLiterals.DetailMovie.posterTitle
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(resource: .faveFlicksWhite)
        return label
    }()
    
    let posterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let edgeInset: CGFloat = 10
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = edgeInset
        layout.sectionInset = UIEdgeInsets(top: 0, left: edgeInset, bottom: 0, right: edgeInset)
        layout.itemSize = CGSize(width: 90, height: 120)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
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
    
    func configureView(_ detailMovie: DetailMovie) {
        calendarDateLabel.text = detailMovie.releaseDate
        starRateLabel.text = String(format: "%.1f", detailMovie.voteAverage)
        
        let genreArray = detailMovie.genreIDArray.map { GenreType(num: $0).description }.prefix(2)
        genreLabel.text = genreArray.joined(separator: StringLiterals.DetailMovie.comma)
        
        let overview = !detailMovie.overview.isEmpty ? detailMovie.overview : StringLiterals.DetailMovie.emptySynopsis
        synopsisDescriptionLabel.text = overview
    }
    
    func configurePageControl(numberOfPages: Int) {
        backdropPageControl.numberOfPages = numberOfPages
        backdropPageControl.currentPage = 0
    }
    
    private func configureView() {
        backgroundColor = UIColor(resource: .faveFlicksBlack)
    }
    
    private func configureHierarchy() {
        addSubviews(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(
            backdropCollectionView,
            backdropPageControl,
            movieInfoStackView,
            synopsisTitleLabel,
            moreHideButton,
            synopsisDescriptionLabel,
            castTitleLabel,
            castCollectionView,
            posterTitleLabel,
            posterCollectionView
        )
        
        movieInfoStackView.addArrangedSubviews(
            calendarImageView,
            calendarDateLabel,
            firstVerticalView,
            starImageView,
            starRateLabel,
            secondVerticalView,
            filmImageView,
            genreLabel
        )
    }
    
    private func configureLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalTo(scrollView)
            $0.verticalEdges.equalTo(scrollView)
        }
        
        backdropCollectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.width * 9 / 16)
        }
        
        backdropPageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(backdropCollectionView).offset(-5)
            $0.height.equalTo(20)
        }
        
        movieInfoStackView.snp.makeConstraints {
            $0.top.equalTo(backdropCollectionView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        calendarImageView.snp.makeConstraints {
            $0.size.equalTo(12)
        }
        
        firstVerticalView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(14)
        }
        
        starImageView.snp.makeConstraints {
            $0.size.equalTo(12)
        }
        
        secondVerticalView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(14)
        }
        
        filmImageView.snp.makeConstraints {
            $0.size.equalTo(12)
        }
        
        synopsisTitleLabel.snp.makeConstraints {
            $0.top.equalTo(movieInfoStackView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(15)
        }
        
        moreHideButton.snp.makeConstraints {
            $0.centerY.equalTo(synopsisTitleLabel)
            $0.trailing.equalToSuperview().inset(15)
        }
        
        synopsisDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(synopsisTitleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(15)
        }
        
        castTitleLabel.snp.makeConstraints {
            $0.top.equalTo(synopsisDescriptionLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(15)
        }
        
        castCollectionView.snp.makeConstraints {
            $0.top.equalTo(castTitleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(130)
        }
        
        posterTitleLabel.snp.makeConstraints {
            $0.top.equalTo(castCollectionView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(15)
        }
        
        posterCollectionView.snp.makeConstraints {
            $0.top.equalTo(posterTitleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(120)
            $0.bottom.equalToSuperview().inset(15)
        }
    }
}
