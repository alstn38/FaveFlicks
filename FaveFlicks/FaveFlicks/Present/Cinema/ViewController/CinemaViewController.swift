//
//  CinemaViewController.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/25/25.
//

import UIKit

final class CinemaViewController: UIViewController {
    
    private let cinemaView = CinemaView()
    private let sampleRecentSearched: [String] = ["현빈", "스파이더", "해리포터", "소방관", "크리스마스"]
    
    override func loadView() {
        view = cinemaView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureCollectionView()
    }
    
    private func configureNavigation() {
        let searchButton = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(searchButtonDidTap)
        )
        
        navigationItem.title = StringLiterals.Cinema.title
        navigationItem.backButtonTitle = StringLiterals.NavigationItem.backButtonTitle
        navigationItem.rightBarButtonItem = searchButton
    }
    
    private func configureCollectionView() {
        cinemaView.recentSearchedCollectionView.delegate = self
        cinemaView.recentSearchedCollectionView.dataSource = self
        cinemaView.recentSearchedCollectionView.register(
            RecentSearchedCollectionViewCell.self,
            forCellWithReuseIdentifier: RecentSearchedCollectionViewCell.identifier
        )
        
        cinemaView.todayMovieCollectionView.delegate = self
        cinemaView.todayMovieCollectionView.dataSource = self
        cinemaView.todayMovieCollectionView.register(
            TodayMovieCollectionViewCell.self,
            forCellWithReuseIdentifier: TodayMovieCollectionViewCell.identifier
        )
    }
    
    @objc private func searchButtonDidTap(_ sender: UIBarButtonItem) {
        
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension CinemaViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case cinemaView.recentSearchedCollectionView:
            return sampleRecentSearched.count
            
        case cinemaView.todayMovieCollectionView:
            return 10
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case cinemaView.recentSearchedCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecentSearchedCollectionViewCell.identifier,
                for: indexPath
            ) as? RecentSearchedCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configureCell(sampleRecentSearched[indexPath.item])
            return cell
            
        case cinemaView.todayMovieCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TodayMovieCollectionViewCell.identifier,
                for: indexPath
            ) as? TodayMovieCollectionViewCell else { return UICollectionViewCell() }
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case cinemaView.todayMovieCollectionView:
            let height = cinemaView.todayMovieCollectionView.frame.height
            let width = height * 3 / 5
            
            return CGSize(width: width, height: height)
            
        default:
            return .zero
        }
    }
}
