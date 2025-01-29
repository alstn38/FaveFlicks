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
        fetchMovieImage(movieID: detailMovie.id)
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
        print(endPoint.url)
        NetworkService.shared.request(endPoint: endPoint, responseType: MovieImage.self) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let value):
                dump(value)
                self.backdropImageArray = value.backdrops
                self.posterImageArray = value.posters
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
            return 10
            
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
