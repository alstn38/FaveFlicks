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
    
    private let serverDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = StringLiterals.Search.serverDateFormatter
        return formatter
    }()
    
    private let presentDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = StringLiterals.Search.presentDateFormatter
        return formatter
    }()

    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureAddObserver()
        configureSearchBar()
        configureCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureResponder()
    }
    
    func configureRecentSearchResult(searchedText: String) {
        self.searchedText = searchedText
        searchView.searchBar.text = searchedText
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
    
    private func configureAddObserver() {
        NotificationCenter.default.addObserver(
            forName: Notification.Name.updateFavoriteMovieDictionary,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            self?.searchView.searchCollectionView.reloadData()
        }
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
    
    private func changeReleaseDateFormatter(_ serverTime: String) -> String {
        let date = serverDateFormatter.date(from: serverTime)
        
        guard let date else {
            return StringLiterals.Search.noServerDate
        }
        
        let presentTimeString = presentDateFormatter.string(from: date)
        return presentTimeString
    }
    
    private func insertRecentSearchedTextArray(searchedText: String) {
        var recentSearchedTextArray = UserDefaultManager.shared.recentSearchedTextArray
        recentSearchedTextArray.removeAll(where: { $0 == searchedText })
        recentSearchedTextArray.insert(searchedText, at: 0)
        UserDefaultManager.shared.recentSearchedTextArray = recentSearchedTextArray
    }
    
    @objc private func searchCellFavoriteButtonDidTap(_ sender: UIButton) {
        let movieID = String(searchedMovieArray[sender.tag].id)
        let isFavoriteMovie = UserDefaultManager.shared.favoriteMovieDictionary.keys.contains(movieID)
        
        switch isFavoriteMovie {
        case true:
            UserDefaultManager.shared.favoriteMovieDictionary.removeValue(forKey: movieID)
            
        case false:
            UserDefaultManager.shared.favoriteMovieDictionary[movieID] = true
        }
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        guard let searchedText = searchBar.text else { return }
        self.searchedText = searchedText
        self.currentPage = 1
        fetchSearchedMovie(query: searchedText, page: currentPage)
        insertRecentSearchedTextArray(searchedText: searchedText)
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
        
        let movieDetail = searchedMovieArray[indexPath.item]
        let presentDate = changeReleaseDateFormatter(movieDetail.releaseDate)
        let newResult = movieDetail.changeReleaseDate(presentDate)
        let searchedText = searchedText ?? ""
        
        cell.configureCell(newResult, searchedText: searchedText)
        cell.favoriteButton.tag = indexPath.item
        cell.favoriteButton.addTarget(self, action: #selector(searchCellFavoriteButtonDidTap), for: .touchUpInside)
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
