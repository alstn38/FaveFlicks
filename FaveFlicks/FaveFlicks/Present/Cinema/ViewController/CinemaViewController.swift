//
//  CinemaViewController.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/25/25.
//

import UIKit

final class CinemaViewController: UIViewController {
    
    private let viewModel: CinemaViewModel
    private let input: CinemaViewModel.Input
    private let cinemaView = CinemaView()
    
    init(viewModel: CinemaViewModel) {
        self.viewModel = viewModel
        self.input = CinemaViewModel.Input(
            viewDidLoad: CurrentValueRelay(()),
            searchButtonDidTap: CurrentValueRelay(()),
            userInfoViewDidTap: CurrentValueRelay(()),
            recentSearchedCellDidTap: CurrentValueRelay(0),
            recentSearchedDeleteButton: CurrentValueRelay(.all),
            todayMovieCellDidTap: CurrentValueRelay(0),
            todayMovieCellFavoriteButtonDidTap: CurrentValueRelay(0)
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = cinemaView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBindData()
        configureNavigation()
        configureTapGestureRecognizer()
        configureAddTarget()
        configureCollectionView()
        input.viewDidLoad.send(())
    }
    
    private func configureBindData() {
        let output = viewModel.transform(from: input)
        
        output.moveToOtherViewController.bind { [weak self] otherControllerType in
            guard let self else { return }
            
            switch otherControllerType {
            case .search(let searchedText):
                let searchViewModel = SearchViewModel(recentSearchText: searchedText)
                let searchViewController = SearchViewController(viewModel: searchViewModel)
                navigationController?.pushViewController(searchViewController, animated: true)
                
            case .userInfo:
                presentProfileNickNameViewController()
                
            case .detailMovie(let detailMovie):
                let detailMovieViewModel = DetailMovieViewModel(detailMovie: detailMovie)
                let detailMovieViewController = DetailMovieViewController(viewModel: detailMovieViewModel)
                navigationController?.pushViewController(detailMovieViewController, animated: true)
            }
        }
        
        output.updateUserInfo.bind { [weak self] _ in
            guard let self else { return }
            cinemaView.userInfoView.updateUserInfo()
        }
        
        output.updateRecentSearched.bind { [weak self] _ in
            guard let self else { return }
            cinemaView.recentSearchedCollectionView.reloadData()
        }
        
        output.recentSearchedEmptyState.bind { [weak self] isEmpty in
            guard let self else { return }
            cinemaView.recentSearchedDeleteButton.isHidden = isEmpty
            cinemaView.noRecentSearchedGuideLabel.isHidden = !isEmpty
        }
        
        output.updateTodayMove.bind { [weak self] _ in
            guard let self else { return }
            cinemaView.todayMovieCollectionView.reloadData()
        }
        
        output.presentError.bind { [weak self] (title, message) in
            guard let self else { return }
            presentAlert(title: title, message: message)
        }
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
    
    private func configureTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userInfoViewDidTap))
        cinemaView.userInfoView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func configureAddTarget() {
        cinemaView.recentSearchedDeleteButton.addTarget(
            self,
            action: #selector(recentSearchedDeleteButtonDidTap),
            for: .touchUpInside
        )
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
    
    private func presentProfileNickNameViewController() {
        let profileNickNameViewModel = ProfileNickNameViewModel(presentationStyleType: .modal)
        let profileNickNameViewController = ProfileNickNameViewController(viewModel: profileNickNameViewModel)
        let profileNickNameNavigationController = UINavigationController(rootViewController: profileNickNameViewController)
        profileNickNameNavigationController.modalPresentationStyle = .pageSheet
        
        if let sheet = profileNickNameNavigationController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 30
        }
        
        present(profileNickNameNavigationController, animated: true)
    }
    
    @objc private func searchButtonDidTap(_ sender: UIBarButtonItem) {
        input.searchButtonDidTap.send(())
    }
    
    @objc private func userInfoViewDidTap(_ sender: UITapGestureRecognizer) {
        input.userInfoViewDidTap.send(())
    }
    
    @objc private func recentSearchedDeleteButtonDidTap(_ sender: UIButton) {
        input.recentSearchedDeleteButton.send(.all)
    }
    
    @objc private func recentSearchedCellDeleteButtonDidTap(_ sender: UIButton) {
        input.recentSearchedDeleteButton.send(.index(sender.tag))
    }
    
    @objc private func todayMovieCellFavoriteButtonDidTap(_ sender: UIButton) {
        input.todayMovieCellFavoriteButtonDidTap.send(sender.tag)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension CinemaViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case cinemaView.recentSearchedCollectionView:
            return viewModel.recentSearchTextArray.count
            
        case cinemaView.todayMovieCollectionView:
            return viewModel.trendMovieArray.count
            
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
            
            cell.configureCell(viewModel.recentSearchTextArray[indexPath.item])
            cell.deleteButton.tag = indexPath.item
            cell.deleteButton.addTarget(
                self,
                action: #selector(recentSearchedCellDeleteButtonDidTap),
                for: .touchUpInside
            )
            return cell
            
        case cinemaView.todayMovieCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TodayMovieCollectionViewCell.identifier,
                for: indexPath
            ) as? TodayMovieCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configureCell(viewModel.trendMovieArray[indexPath.item])
            cell.favoriteButton.tag = indexPath.item
            cell.favoriteButton.addTarget(
                self,
                action: #selector(todayMovieCellFavoriteButtonDidTap),
                for: .touchUpInside
            )
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case cinemaView.recentSearchedCollectionView:
            input.recentSearchedCellDidTap.send(indexPath.item)
            
        case cinemaView.todayMovieCollectionView:
            input.todayMovieCellDidTap.send(indexPath.item)
            
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
