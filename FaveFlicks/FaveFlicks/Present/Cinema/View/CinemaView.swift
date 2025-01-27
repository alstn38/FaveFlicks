//
//  CinemaView.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/25/25.
//

import SnapKit
import UIKit

final class CinemaView: UIView {
    
    let userInfoView = UserInfoView()
    
    private let recentSearchedTitleLabel: UILabel = {
        let label = UILabel()
        label.text = StringLiterals.Cinema.recentSearchedTitle
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(resource: .faveFlicksWhite)
        label.textAlignment = .center
        return label
    }()
    
    private let recentSearchedDeleteButton: UIButton = {
        let button = UIButton()
        button.setTitle(StringLiterals.Cinema.recentSearchedDelete, for: .normal)
        button.setTitleColor(UIColor(resource: .faveFlicsMain), for: .normal)
        button.setTitleColor(UIColor(resource: .faveFlicksGray), for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        return button
    }()
    
    let recentSearchedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let insetSpacing: CGFloat = 10
        let sectionInset: CGFloat = 15
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = insetSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: sectionInset, bottom: 0, right: sectionInset)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(resource: .faveFlicksBlack)
        return collectionView
    }()
    
    let noRecentSearchedGuideLabel: UILabel = {
        let label = UILabel()
        label.text = StringLiterals.Cinema.noRecentSearchedGuide
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = UIColor(resource: .faveFlicksGray)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let todayMovieTitleLabel: UILabel = {
        let label = UILabel()
        label.text = StringLiterals.Cinema.todayMovieTitle
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(resource: .faveFlicksWhite)
        label.textAlignment = .center
        return label
    }()
    
    lazy var todayMovieCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let insetSpacing: CGFloat = 10
        let sectionInset: CGFloat = 15
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = insetSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: sectionInset, bottom: 0, right: sectionInset)
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
    
    private func configureView() {
        backgroundColor = UIColor(resource: .faveFlicksBlack)
    }
    
    private func configureHierarchy() {
        addSubviews(
            userInfoView,
            recentSearchedTitleLabel,
            recentSearchedDeleteButton,
            recentSearchedCollectionView,
            noRecentSearchedGuideLabel,
            todayMovieTitleLabel,
            todayMovieCollectionView
        )
    }
    
    private func configureLayout() {
        userInfoView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        recentSearchedTitleLabel.snp.makeConstraints {
            $0.top.equalTo(userInfoView.snp.bottom).offset(15)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(15)
        }
        
        recentSearchedDeleteButton.snp.makeConstraints {
            $0.centerY.equalTo(recentSearchedTitleLabel)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(15)
        }
        
        recentSearchedCollectionView.snp.makeConstraints {
            $0.top.equalTo(recentSearchedTitleLabel.snp.bottom).offset(15)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(24)
        }
        
        noRecentSearchedGuideLabel.snp.makeConstraints {
            $0.center.equalTo(recentSearchedCollectionView)
        }
        
        todayMovieTitleLabel.snp.makeConstraints {
            $0.top.equalTo(recentSearchedCollectionView.snp.bottom).offset(15)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(15)
        }
        
        todayMovieCollectionView.snp.makeConstraints {
            $0.top.equalTo(todayMovieTitleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
