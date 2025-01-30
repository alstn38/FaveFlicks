//
//  SearchViewController.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/28/25.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private let searchView = SearchView()
    private var searchedText: String?
    private var currentPage: Int = 1
    private var totalPage: Int = 1
    private var isRecentSearchResult: Bool = false
    
    private var searchedMovieArray: [DetailMovie] = [] {
        didSet {
            let isEmptySearchedMovieArray = searchedMovieArray.isEmpty
            searchView.searchCollectionView.isHidden = isEmptySearchedMovieArray
            searchView.noSearchResultLabel.isHidden = !isEmptySearchedMovieArray
            searchView.searchCollectionView.reloadData()
        }
    }

    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureSearchBar()
        configureCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureResponder()
    }
    
    func configureRecentSearchResult(searchedText: String) {
        isRecentSearchResult = true
        fetchSearchedMovie(query: searchedText, page: currentPage)
    }
    
    private func configureNavigation() {
        navigationItem.backButtonTitle = StringLiterals.NavigationItem.backButtonTitle
        navigationItem.title = StringLiterals.Search.title
    }
    
    private func configureResponder() {
        guard !isRecentSearchResult else { return }
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
    
    private func fetchSearchedMovie(query: String, page: Int) {
        let endPoint = SearchEndPoint.movie(query: query, page: page)
        NetworkService.shared.request(endPoint: endPoint, responseType: SearchMovie.self) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let value):
                updateMovieArray(value)
            case .failure(let error):
                self.presentAlert(title: StringLiterals.Alert.networkError, message: error.description)
            }
        }
    }
    
    private func updateMovieArray(_ searchMovie: SearchMovie) {
        if currentPage == 1 {
            totalPage = searchMovie.totalPages
            searchedMovieArray = searchMovie.results
        } else {
            searchedMovieArray.append(contentsOf: searchMovie.results)
        }
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        guard let searchedText = searchBar.text else { return }
        self.searchedText = searchedText
        fetchSearchedMovie(query: searchedText, page: currentPage)
        UserDefaultManager.shared.recentSearchedTextArrayKey.append(searchedText)
        NotificationCenter.default.post(name: Notification.Name.updateRecentSearchTextArray, object: nil)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedMovieArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchCollectionViewCell.identifier,
            for: indexPath
        ) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureCell(searchedMovieArray[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailMovie = searchedMovieArray[indexPath.item]
        let detailMovieViewController = DetailMovieViewController(detailMovie: detailMovie)
        navigationController?.pushViewController(detailMovieViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard currentPage < totalPage else { return }
        guard let searchedText else { return }
        
        if searchedMovieArray.count - 2 == indexPath.item {
            currentPage += 1
            
            fetchSearchedMovie(query: searchedText, page: currentPage)
        }
    }
}
