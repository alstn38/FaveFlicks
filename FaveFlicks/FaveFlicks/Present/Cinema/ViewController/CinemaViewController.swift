//
//  CinemaViewController.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/25/25.
//

import UIKit

final class CinemaViewController: UIViewController {
    
    private let cinemaView = CinemaView()
    
    private var recentSearchTextArray: [String] = UserDefaultManager.shared.recentSearchedTextArrayKey {
        didSet {
            configureRecentSearch()
            cinemaView.recentSearchedCollectionView.reloadData()
        }
    }
    
    private var trendMovieArray: [DetailMovie] = [] {
        didSet {
            cinemaView.todayMovieCollectionView.reloadData()
        }
    }
    
    override func loadView() {
        view = cinemaView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        addObserver()
        configureUserInfoView()
        configureRecentSearch()
        configureTapGestureRecognizer()
        configureAddTarget()
        configureCollectionView()
        fetchTrendMovie()
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
    
    private func addObserver() {
        NotificationCenter.default.addObserver(
            forName: Notification.Name.updateUserInfo,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            self?.cinemaView.userInfoView.updateUserInfo()
        }
        
        NotificationCenter.default.addObserver(
            forName: Notification.Name.updateRecentSearchTextArray,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            self?.recentSearchTextArray = UserDefaultManager.shared.recentSearchedTextArrayKey
        }
    }
    
    private func configureUserInfoView() {
        cinemaView.userInfoView.updateUserInfo()
    }
    
    private func configureRecentSearch() {
        let isEmptyRecentSearchTextArray = recentSearchTextArray.isEmpty
        cinemaView.noRecentSearchedGuideLabel.isHidden = !isEmptyRecentSearchTextArray
        cinemaView.recentSearchedDeleteButton.isHidden = isEmptyRecentSearchTextArray
    }
    
    private func configureTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userInfoViewDidTap))
        cinemaView.userInfoView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func configureAddTarget() {
        cinemaView.recentSearchedDeleteButton.addTarget(self, action: #selector(recentSearchedDeleteButtonDidTap), for: .touchUpInside)
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
    
    private func fetchTrendMovie() {
        let endPoint = TrendEndPoint.movie
        NetworkService.shared.request(endPoint: endPoint, responseType: TrendMovie.self) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let value):
                trendMovieArray = value.results
            case .failure(let error):
                self.presentAlert(title: StringLiterals.Alert.networkError, message: error.description)
            }
        }
    }
    
    @objc private func searchButtonDidTap(_ sender: UIBarButtonItem) {
        let searchViewController = SearchViewController()
        navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    @objc private func userInfoViewDidTap(_ sender: UITapGestureRecognizer) {
        let profileNickNameViewController = ProfileNickNameViewController(presentationStyleType: .modal)
        let profileNickNameNavigationController = UINavigationController(rootViewController: profileNickNameViewController)
        profileNickNameNavigationController.modalPresentationStyle = .pageSheet
        
        if let sheet = profileNickNameNavigationController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 30
        }
        
        present(profileNickNameNavigationController, animated: true)
    }
    
    @objc private func recentSearchedDeleteButtonDidTap(_ sender: UIButton) {
        UserDefaultManager.shared.recentSearchedTextArrayKey.removeAll()
        recentSearchTextArray = UserDefaultManager.shared.recentSearchedTextArrayKey
    }
    
    @objc private func recentSearchedCellDeleteButtonDidTap(_ sender: UIButton) {
        UserDefaultManager.shared.recentSearchedTextArrayKey.remove(at: sender.tag)
        recentSearchTextArray = UserDefaultManager.shared.recentSearchedTextArrayKey
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension CinemaViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case cinemaView.recentSearchedCollectionView:
            return recentSearchTextArray.count
            
        case cinemaView.todayMovieCollectionView:
            return trendMovieArray.count
            
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
            
            cell.configureCell(recentSearchTextArray[indexPath.item])
            cell.deleteButton.tag = indexPath.item
            cell.deleteButton.addTarget(self, action: #selector(recentSearchedCellDeleteButtonDidTap), for: .touchUpInside)
            return cell
            
        case cinemaView.todayMovieCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TodayMovieCollectionViewCell.identifier,
                for: indexPath
            ) as? TodayMovieCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configureCell(trendMovieArray[indexPath.item])
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case cinemaView.recentSearchedCollectionView:
            let recentSearchedText = recentSearchTextArray[indexPath.item]
            let searchViewController = SearchViewController()
            searchViewController.configureRecentSearchResult(searchedText: recentSearchedText)
            navigationController?.pushViewController(searchViewController, animated: true)
            
        case cinemaView.todayMovieCollectionView:
            let detailMovie = trendMovieArray[indexPath.item]
            let detailMovieViewController = DetailMovieViewController(detailMovie: detailMovie)
            navigationController?.pushViewController(detailMovieViewController, animated: true)
            
        default:
            return
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
