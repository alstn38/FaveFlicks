//
//  DetailMovieViewModel.swift
//  FaveFlicks
//
//  Created by 강민수 on 2/12/25.
//

import Foundation

final class DetailMovieViewModel: InputOutputModel {
    
    struct Input {
        let viewDidLoad: CurrentValueRelay<Void>
        let favoriteButtonDidTap: CurrentValueRelay<Void>
        let moreHideButtonDidTap: CurrentValueRelay<Void>
    }
    
    struct Output {
        let updateFavoriteButton: BehaviorSubject<Bool>
        let updateBackdrop: CurrentValueRelay<Void>
        let updateDetailMovieInfo: CurrentValueRelay<DetailMovie?>
        let updateCastInfo: CurrentValueRelay<Void>
        let updatePosterInfo: CurrentValueRelay<Void>
        let moreHideButtonState: BehaviorSubject<SynopsisLineType>
        let presentError: CurrentValueRelay<(title: String, message: String)>
    }
    
    private let output = Output(
        updateFavoriteButton: BehaviorSubject(false),
        updateBackdrop: CurrentValueRelay(()),
        updateDetailMovieInfo: CurrentValueRelay(nil),
        updateCastInfo: CurrentValueRelay(()),
        updatePosterInfo: CurrentValueRelay(()),
        moreHideButtonState: BehaviorSubject(.more),
        presentError: CurrentValueRelay((title: "", message: ""))
    )
    
    let detailMovie: DetailMovie
    private(set) var backdropImageArray: [DetailImage] = []
    private(set) var castArray: [Cast] = []
    private(set) var posterImageArray: [DetailImage] = []
    private var synopsisLineType: SynopsisLineType = .more
    private var isFavoriteMovie: Bool {
        return UserDefaultManager.shared.favoriteMovieDictionary.keys.contains(String(detailMovie.id))
    }
    
    init(detailMovie: DetailMovie) {
        self.detailMovie = detailMovie
    }
    
    func transform(from input: Input) -> Output {
        input.viewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            output.updateDetailMovieInfo.send(detailMovie)
            output.updateFavoriteButton.send(isFavoriteMovie)
            fetchMovieImage()
            fetchCastInfo()
        }
        
        input.favoriteButtonDidTap.bind { [weak self] _ in
            guard let self else { return }
            changeFavoriteState()
            output.updateFavoriteButton.send(isFavoriteMovie)
        }
        
        input.moreHideButtonDidTap.bind { [weak self] _ in
            guard let self else { return }
            synopsisLineType.toggle()
            output.moreHideButtonState.send(synopsisLineType)
        }
        
        return output
    }
    
    private func fetchMovieImage() {
        let endPoint = MovieImageEndPoint.movie(movieID: detailMovie.id)
        NetworkService.shared.request(endPoint: endPoint, responseType: MovieImage.self) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let value):
                backdropImageArray = Array(value.backdrops.prefix(5))
                output.updateBackdrop.send(())
                
                posterImageArray = value.posters
                output.updatePosterInfo.send(())
                
            case .failure(let error):
                output.presentError.send((title: StringLiterals.Alert.networkError, message: error.description))
            }
        }
    }
    
    private func fetchCastInfo() {
        let endPoint = CreditEndPoint.movie(movieID: detailMovie.id)
        NetworkService.shared.request(endPoint: endPoint, responseType: Credit.self) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let value):
                castArray = value.cast
                output.updateCastInfo.send(())
                
            case .failure(let error):
                output.presentError.send((title: StringLiterals.Alert.networkError, message: error.description))
            }
        }
    }
    
    private func changeFavoriteState() {
        let movieID = String(detailMovie.id)
        let isFavoriteMovie = UserDefaultManager.shared.favoriteMovieDictionary.keys.contains(String(detailMovie.id))
        
        switch isFavoriteMovie {
        case true:
            UserDefaultManager.shared.favoriteMovieDictionary.removeValue(forKey: movieID)
            
        case false:
            UserDefaultManager.shared.favoriteMovieDictionary[movieID] = true
        }
    }
}

// MARK: - DetailMovieViewModel CustomType
extension DetailMovieViewModel {
    
    enum SynopsisLineType {
        case hide
        case more
        
        var numberOfLines: Int {
            switch self {
            case .hide:
                return 0
            case .more:
                return 3
            }
        }
        
        var isSelected: Bool {
            switch self {
            case .hide:
                return true
            case .more:
                return false
            }
        }
        
        mutating func toggle() {
            if self == .hide {
                self = .more
            } else {
                self = .hide
            }
        }
    }
}
