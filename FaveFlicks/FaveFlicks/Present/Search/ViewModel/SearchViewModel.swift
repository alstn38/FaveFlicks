//
//  SearchViewModel.swift
//  FaveFlicks
//
//  Created by 강민수 on 2/11/25.
//

import Foundation

final class SearchViewModel: InputOutputModel {
    
    struct Input {
        let viewDidLoad: CurrentValueRelay<Void>
        let searchButtonDidTap: CurrentValueRelay<String>
        let favoriteButtonDidTap: CurrentValueRelay<Int>
        let searchedMovieCellDidTap: CurrentValueRelay<Int>
        let searchMovieWillDisplayIndex: CurrentValueRelay<Int>
    }
    
    struct Output {
        let updateSearchResult: CurrentValueRelay<updateSearchResultType>
        let moveToDetailMovieController: CurrentValueRelay<DetailMovie?>
        let searchResultIsEmptyState: CurrentValueRelay<Bool>
        let scrollToTop: CurrentValueRelay<Void>
        let presentError: CurrentValueRelay<(title: String, message: String)>
    }
    
    private let output = Output(
        updateSearchResult: CurrentValueRelay(.all),
        moveToDetailMovieController: CurrentValueRelay(nil),
        searchResultIsEmptyState: CurrentValueRelay(false),
        scrollToTop: CurrentValueRelay(()),
        presentError: CurrentValueRelay((title: "", message: ""))
    )
    
    let isRecentSearchResult: Bool
    private(set) var recentSearchText: String?
    private(set) var searchedMovieArray: [DetailMovie] = []
    private var totalPage = 1
    private var currentPage = 1
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
    
    init(recentSearchText: String? = nil) {
        self.isRecentSearchResult = (recentSearchText != nil)
        self.recentSearchText = recentSearchText
        addObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func transform(from input: Input) -> Output {
        input.viewDidLoad.bind { [weak self] _ in
            guard let self,
                  let recentSearchText,
                  isRecentSearchResult
            else { return }
            fetchSearchedMovie(query: recentSearchText, page: currentPage)
        }
        
        input.searchButtonDidTap.bind { [weak self] searchedText in
            guard let self else { return }
            guard recentSearchText != searchedText else {
                output.scrollToTop.send(())
                return
            }
            currentPage = 1
            recentSearchText = searchedText
            fetchSearchedMovie(query: searchedText, page: currentPage)
            insertRecentSearchedTextArray(searchedText: searchedText)
        }
        
        input.favoriteButtonDidTap.bind { [weak self] index in
            guard let self else { return }
            updateFavoriteMovie(at: index)
            output.updateSearchResult.send(.select(at: index))
        }
        
        input.searchedMovieCellDidTap.bind { [weak self] index in
            guard let self else { return }
            let detailMovie = searchedMovieArray[index]
            output.moveToDetailMovieController.send(detailMovie)
        }
        
        input.searchMovieWillDisplayIndex.bind { [weak self] index in
            guard let self,
                  let recentSearchText,
                  currentPage < totalPage
            else { return }
            
            if searchedMovieArray.count - 2 == index {
                currentPage += 1
                
                fetchSearchedMovie(query: recentSearchText, page: currentPage)
            }
        }
        
        return output
    }
    
    func changeReleaseDateFormatter(_ serverTime: String) -> String {
        let date = serverDateFormatter.date(from: serverTime)
        
        guard let date else {
            return StringLiterals.Search.noServerDate
        }
        
        let presentTimeString = presentDateFormatter.string(from: date)
        return presentTimeString
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(
            forName: Notification.Name.updateFavoriteMovieDictionary,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            guard let self else { return }
            output.updateSearchResult.send(.all)
        }
    }
    
    private func fetchSearchedMovie(query: String, page: Int) {
        let endPoint = SearchEndPoint.movie(query: query, page: page)
        NetworkService.shared.request(endPoint: endPoint, responseType: SearchMovie.self) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let value):
                updateMovieArray(value)
                
            case .failure(let error):
                output.presentError.send((
                    title: StringLiterals.Alert.networkError,
                    message: error.description
                ))
            }
        }
    }
    
    private func updateMovieArray(_ searchMovie: SearchMovie) {
        if currentPage == 1 {
            totalPage = searchMovie.totalPages
            searchedMovieArray = searchMovie.results
            output.updateSearchResult.send(.all)
            output.scrollToTop.send(())
            output.searchResultIsEmptyState.send(searchedMovieArray.isEmpty)
        } else {
            searchedMovieArray.append(contentsOf: searchMovie.results)
            output.updateSearchResult.send(.all)
        }
    }
    
    private func insertRecentSearchedTextArray(searchedText: String) {
        var recentSearchedTextArray = UserDefaultManager.shared.recentSearchedTextArray
        recentSearchedTextArray.removeAll(where: { $0 == searchedText })
        recentSearchedTextArray.insert(searchedText, at: 0)
        UserDefaultManager.shared.recentSearchedTextArray = recentSearchedTextArray
    }
    
    private func updateFavoriteMovie(at index: Int) {
        let movieID = String(searchedMovieArray[index].id)
        let isFavoriteMovie = UserDefaultManager.shared.favoriteMovieDictionary.keys.contains(movieID)
        
        switch isFavoriteMovie {
        case true:
            UserDefaultManager.shared.favoriteMovieDictionary.removeValue(forKey: movieID)
            
        case false:
            UserDefaultManager.shared.favoriteMovieDictionary[movieID] = true
        }
    }
}

extension SearchViewModel {
    
    enum updateSearchResultType {
        case all
        case select(at: Int)
    }
}
