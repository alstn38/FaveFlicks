//
//  CinemaViewModel.swift
//  FaveFlicks
//
//  Created by 강민수 on 2/11/25.
//

import Foundation

final class CinemaViewModel: InputOutputModel {
    
    struct Input {
        let viewDidLoad: CurrentValueRelay<Void>
        let searchButtonDidTap: CurrentValueRelay<Void>
        let userInfoViewDidTap: CurrentValueRelay<Void>
        let recentSearchedCellDidTap: CurrentValueRelay<Int>
        let recentSearchedDeleteButton: CurrentValueRelay<RecentSearchedDeleteType>
        let todayMovieCellDidTap: CurrentValueRelay<Int>
        let todayMovieCellFavoriteButtonDidTap: CurrentValueRelay<Int>
    }
    
    struct Output {
        let moveToOtherViewController: CurrentValueRelay<MoveToOtherControllerType>
        let updateUserInfo: BehaviorSubject<Void>
        let updateRecentSearched: BehaviorSubject<Void>
        let recentSearchedEmptyState: BehaviorSubject<Bool>
        let updateTodayMove: CurrentValueRelay<Void>
        let presentError: CurrentValueRelay<(title: String, message: String)>
    }
    
    private let output = Output(
        moveToOtherViewController: CurrentValueRelay(.userInfo),
        updateUserInfo: BehaviorSubject(()),
        updateRecentSearched: BehaviorSubject(()),
        recentSearchedEmptyState: BehaviorSubject(true),
        updateTodayMove: CurrentValueRelay(()),
        presentError: CurrentValueRelay(("", ""))
    )
    
    private(set) var recentSearchTextArray: [String] = UserDefaultManager.shared.recentSearchedTextArray
    private(set) var trendMovieArray: [DetailMovie] = []
    
    init() {
        addObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func transform(from input: Input) -> Output {
        input.viewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            fetchTrendMovie()
            output.recentSearchedEmptyState.send(recentSearchTextArray.isEmpty)
        }
        
        input.searchButtonDidTap.bind { [weak self] _ in
            guard let self else { return }
            output.moveToOtherViewController.send(.search())
        }
        
        input.userInfoViewDidTap.bind { [weak self] _ in
            guard let self else { return }
            output.moveToOtherViewController.send(.userInfo)
        }
        
        input.recentSearchedCellDidTap.bind { [weak self] index in
            guard let self else { return }
            let recentSearchedText = recentSearchTextArray[index]
            output.moveToOtherViewController.send(.search(recentSearchedText))
        }
        
        input.recentSearchedDeleteButton.bind { recentSearchedDeleteType in
            switch recentSearchedDeleteType {
            case .all:
                UserDefaultManager.shared.recentSearchedTextArray = []
            case .index(let index):
                UserDefaultManager.shared.recentSearchedTextArray.remove(at: index)
            }
        }
        
        input.todayMovieCellDidTap.bind { [weak self] index in
            guard let self else { return }
            let detailMovie = trendMovieArray[index]
            output.moveToOtherViewController.send(.detailMovie(detailMovie: detailMovie))
        }
        
        input.todayMovieCellFavoriteButtonDidTap.bind { [weak self] index in
            guard let self else { return }
            let movieID = String(trendMovieArray[index].id)
            let isFavoriteMovie = UserDefaultManager.shared.favoriteMovieDictionary.keys.contains(movieID)
            
            switch isFavoriteMovie {
            case true:
                UserDefaultManager.shared.favoriteMovieDictionary.removeValue(forKey: movieID)
                
            case false:
                UserDefaultManager.shared.favoriteMovieDictionary[movieID] = true
            }
        }
        
        return output
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(
            forName: Notification.Name.updateUserInfo,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            guard let self else { return }
            output.updateUserInfo.send(())
        }
        
        NotificationCenter.default.addObserver(
            forName: Notification.Name.updateRecentSearchTextArray,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            guard let self else { return }
            recentSearchTextArray = UserDefaultManager.shared.recentSearchedTextArray
            output.updateRecentSearched.send(())
            output.recentSearchedEmptyState.send(recentSearchTextArray.isEmpty)
        }
        
        NotificationCenter.default.addObserver(
            forName: Notification.Name.updateFavoriteMovieDictionary,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            guard let self else { return }
            output.updateUserInfo.send(())
            output.updateTodayMove.send(())
        }
    }
    
    private func fetchTrendMovie() {
        let endPoint = TrendEndPoint.movie
        NetworkService.shared.request(endPoint: endPoint, responseType: TrendMovie.self) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let value):
                trendMovieArray = value.results
                output.updateTodayMove.send(())
                
            case .failure(let error):
                output.presentError.send((
                    title: StringLiterals.Alert.networkError,
                    message: error.description
                ))
            }
        }
    }
}

// MARK: - CinemaViewModel Custom Type
extension CinemaViewModel {
    
    enum RecentSearchedDeleteType {
        case all
        case index(Int)
    }
    
    enum MoveToOtherControllerType {
        case search(String? = nil)
        case userInfo
        case detailMovie(detailMovie: DetailMovie)
    }
}
