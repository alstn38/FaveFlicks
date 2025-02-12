//
//  SearchViewController.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/28/25.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private let viewModel: SearchViewModel
    private let input: SearchViewModel.Input
    private let searchView = SearchView()
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        self.input = SearchViewModel.Input(
            viewDidLoad: CurrentValueRelay(()),
            searchButtonDidTap: CurrentValueRelay(""),
            favoriteButtonDidTap: CurrentValueRelay(0),
            searchedMovieCellDidTap: CurrentValueRelay(0),
            searchMovieWillDisplayIndex: CurrentValueRelay(0)
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBindData()
        configureNavigation()
        configureRecentSearched()
        configureSearchBar()
        configureCollectionView()
        input.viewDidLoad.send(())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureResponder()
    }
    
    private func configureBindData() {
        let output = viewModel.transform(from: input)
        
        output.updateSearchResult.bind { [weak self] updateSearchResultType in
            guard let self else { return }
            switch updateSearchResultType {
            case .all:
                searchView.searchCollectionView.reloadData()
                
            case .select(let item):
                searchView.searchCollectionView.reloadItems(at: [IndexPath(item: item, section: 0)])
            }
        }
        
        output.moveToDetailMovieController.bind { [weak self] detailMovie in
            guard let self,
                  let detailMovie
            else { return }
            let detailMovieViewModel = DetailMovieViewModel(detailMovie: detailMovie)
            let detailMovieViewController = DetailMovieViewController(viewModel: detailMovieViewModel)
            navigationController?.pushViewController(detailMovieViewController, animated: true)
        }
        
        output.searchResultIsEmptyState.bind { [weak self] isEmpty in
            guard let self else { return }
            searchView.searchCollectionView.isHidden = isEmpty
            searchView.noSearchResultLabel.isHidden = !isEmpty
        }
        
        output.scrollToTop.bind { [weak self] _ in
            guard let self else { return }
            searchView.searchCollectionView.setContentOffset(.zero, animated: false)
        }
        
        output.presentError.bind { [weak self] (title, message) in
            guard let self else { return }
            presentAlert(title: title, message: message)
        }
    }
    
    private func configureNavigation() {
        navigationItem.backButtonTitle = StringLiterals.NavigationItem.backButtonTitle
        navigationItem.title = StringLiterals.Search.title
    }
    
    private func configureRecentSearched() {
        guard viewModel.isRecentSearchResult else { return }
        searchView.searchBar.text = viewModel.recentSearchText
    }
    
    private func configureResponder() {
        guard !viewModel.isRecentSearchResult else { return }
        searchView.searchBar.becomeFirstResponder()
    }
    
    private func configureSearchBar() {
        searchView.searchBar.delegate = self
    }
    
    private func configureCollectionView() {
        searchView.searchCollectionView.delegate = self
        searchView.searchCollectionView.dataSource = self
        searchView.searchCollectionView.register(
            SearchCollectionViewCell.self,
            forCellWithReuseIdentifier: SearchCollectionViewCell.identifier
        )
    }
    
    @objc private func searchCellFavoriteButtonDidTap(_ sender: UIButton) {
        input.favoriteButtonDidTap.send(sender.tag)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        guard let searchedText = searchBar.text else { return }
        input.searchButtonDidTap.send(searchedText)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.searchedMovieArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchCollectionViewCell.identifier,
            for: indexPath
        ) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        
        let movieDetail = viewModel.searchedMovieArray[indexPath.item]
        let presentDate = viewModel.changeReleaseDateFormatter(movieDetail.releaseDate)
        let newResult = movieDetail.changeReleaseDate(presentDate)
        let searchedText = viewModel.recentSearchText ?? ""
        
        cell.configureCell(newResult, searchedText: searchedText)
        cell.favoriteButton.tag = indexPath.item
        cell.favoriteButton.addTarget(
            self,
            action: #selector(searchCellFavoriteButtonDidTap),
            for: .touchUpInside
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        input.searchedMovieCellDidTap.send(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        input.searchMovieWillDisplayIndex.send(indexPath.item)
    }
}
