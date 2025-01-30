//
//  DetailMovieViewController.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/29/25.
//

import UIKit

final class DetailMovieViewController: UIViewController {
    
    private let detailMovieView = DetailMovieView()
    private let detailMovie: DetailMovie
    private var backdropImageArray: [DetailImage] = [] {
        didSet {
            detailMovieView.backdropCollectionView.reloadData()
        }
    }
    
    private var castArray: [Cast] = [] {
        didSet {
            detailMovieView.castCollectionView.reloadData()
        }
    }
    
    private var posterImageArray: [DetailImage] = [] {
        didSet {
            detailMovieView.posterCollectionView.reloadData()
        }
    }
    
    init(detailMovie: DetailMovie) {
        self.detailMovie = detailMovie
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = detailMovieView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureCollectionView()
        detailMovieView.configureView(detailMovie)
        fetchMovieImage(movieID: detailMovie.id)
        fetchCredit(movieID: detailMovie.id)
    }
    
    private func configureNavigation() {
        let favoriteButton = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(favoriteButtonDidTap)
        )
        
        navigationItem.title = detailMovie.title
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    private func configureCollectionView() {
        detailMovieView.backdropCollectionView.delegate = self
        detailMovieView.backdropCollectionView.dataSource = self
        detailMovieView.backdropCollectionView.register(
            BackdropCollectionViewCell.self,
            forCellWithReuseIdentifier: BackdropCollectionViewCell.identifier
        )
        
        detailMovieView.castCollectionView.delegate = self
        detailMovieView.castCollectionView.dataSource = self
        detailMovieView.castCollectionView.register(
            CastCollectionViewCell.self,
            forCellWithReuseIdentifier: CastCollectionViewCell.identifier
        )
        
        detailMovieView.posterCollectionView.delegate = self
        detailMovieView.posterCollectionView.dataSource = self
        detailMovieView.posterCollectionView.register(
            PosterCollectionViewCell.self,
            forCellWithReuseIdentifier: PosterCollectionViewCell.identifier
        )
    }
    
    private func fetchMovieImage(movieID: Int) {
        let endPoint = MovieImageEndPoint.movie(movieID: movieID)
        NetworkService.shared.request(endPoint: endPoint, responseType: MovieImage.self) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let value):
                self.backdropImageArray = Array(value.backdrops.prefix(5))
                self.posterImageArray = value.posters
                self.detailMovieView.configurePageControl(numberOfPages: self.backdropImageArray.count)
            case .failure(let error):
                self.presentAlert(title: StringLiterals.Alert.networkError, message: error.description)
            }
        }
    }
    
    private func fetchCredit(movieID: Int) {
        let endPoint = CreditEndPoint.movie(movieID: movieID)
        NetworkService.shared.request(endPoint: endPoint, responseType: Credit.self) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let value):
                self.castArray = value.cast
            case .failure(let error):
                self.presentAlert(title: StringLiterals.Alert.networkError, message: error.description)
            }
        }
    }
    
    @objc private func favoriteButtonDidTap(_ sender: UIBarButtonItem) {
        
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension DetailMovieViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case detailMovieView.backdropCollectionView:
            return backdropImageArray.count
            
        case detailMovieView.castCollectionView:
            return castArray.count
            
        case detailMovieView.posterCollectionView:
            return posterImageArray.count
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case detailMovieView.backdropCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BackdropCollectionViewCell.identifier,
                for: indexPath
            ) as? BackdropCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configureCell(backdropImageArray[indexPath.item])
            return cell
            
        case detailMovieView.castCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CastCollectionViewCell.identifier,
                for: indexPath
            ) as? CastCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configureCell(castArray[indexPath.item])
            return cell
            
        case detailMovieView.posterCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PosterCollectionViewCell.identifier,
                for: indexPath
            ) as? PosterCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configureCell(posterImageArray[indexPath.item])
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UIScrollViewDelegate
extension DetailMovieViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if fmod(scrollView.contentOffset.x, scrollView.frame.maxX) == 0 {
            let currentPage: Int = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
            detailMovieView.backdropPageControl.currentPage = currentPage
        }
    }
}
