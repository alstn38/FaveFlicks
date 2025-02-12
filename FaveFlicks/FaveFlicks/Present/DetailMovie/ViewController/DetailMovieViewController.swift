//
//  DetailMovieViewController.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/29/25.
//

import UIKit

final class DetailMovieViewController: UIViewController {
    
    private let viewModel: DetailMovieViewModel
    private let input: DetailMovieViewModel.Input
    private let detailMovieView = DetailMovieView()
    
    init(viewModel: DetailMovieViewModel) {
        self.viewModel = viewModel
        self.input = DetailMovieViewModel.Input(
            viewDidLoad: CurrentValueRelay(()),
            favoriteButtonDidTap: CurrentValueRelay(()),
            moreHideButtonDidTap: CurrentValueRelay(())
        )
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
        
        configureBindData()
        configureNavigation()
        configureCollectionView()
        configureAddTarget()
        input.viewDidLoad.send(())
    }
    
    private func configureBindData() {
        let output = viewModel.transform(from: input)
        
        output.updateFavoriteButton.bind { [weak self] isFavorite in
            guard let self else { return }
            configureFavoriteButtonImage(isFavorite: isFavorite)
        }
        
        output.updateBackdrop.bind { [weak self] _ in
            guard let self else { return }
            let isEmptyBackdrop = viewModel.backdropImageArray.isEmpty
            detailMovieView.backdropCollectionView.isHidden = isEmptyBackdrop
            detailMovieView.backdropGuideLabel.isHidden = !isEmptyBackdrop
            detailMovieView.backdropCollectionView.reloadData()
            self.detailMovieView.configurePageControl(numberOfPages: viewModel.backdropImageArray.count)
        }
        
        output.updateDetailMovieInfo.bind { [weak self] detailMovie in
            guard let self else { return }
            detailMovieView.configureView(viewModel.detailMovie)
        }
        
        output.updateCastInfo.bind { [weak self] _ in
            guard let self else { return }
            let isEmptyCast = viewModel.castArray.isEmpty
            detailMovieView.castCollectionView.isHidden = isEmptyCast
            detailMovieView.castGuideLabel.isHidden = !isEmptyCast
            detailMovieView.castCollectionView.reloadData()
        }
        
        output.updatePosterInfo.bind { [weak self] _ in
            guard let self else { return }
            let isEmptyPosterImage = viewModel.posterImageArray.isEmpty
            detailMovieView.posterCollectionView.isHidden = isEmptyPosterImage
            detailMovieView.posterGuideLabel.isHidden = !isEmptyPosterImage
            detailMovieView.posterCollectionView.reloadData()
        }
        
        output.moreHideButtonState.bind { [weak self] synopsisLineType in
            guard let self else { return }
            detailMovieView.synopsisDescriptionLabel.numberOfLines = synopsisLineType.numberOfLines
            detailMovieView.moreHideButton.isSelected = synopsisLineType.isSelected
        }
        
        output.presentError.bind { [weak self] (title, message) in
            guard let self else { return }
            presentAlert(title: title, message: message)
        }
    }
    
    private func configureNavigation() {
        let favoriteButton = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(favoriteButtonDidTap)
        )
        
        navigationItem.title = viewModel.detailMovie.title
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    private func configureFavoriteButtonImage(isFavorite: Bool) {
        let buttonImage = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        navigationItem.rightBarButtonItem?.image = buttonImage
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
    
    private func configureAddTarget() {
        detailMovieView.moreHideButton.addTarget(self, action: #selector(moreHideButtonDidTap), for: .touchUpInside)
    }
    
    @objc private func favoriteButtonDidTap(_ sender: UIBarButtonItem) {
        input.favoriteButtonDidTap.send(())
    }
    
    @objc private func moreHideButtonDidTap(_ sender: UIButton) {
        input.moreHideButtonDidTap.send(())
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension DetailMovieViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case detailMovieView.backdropCollectionView:
            return viewModel.backdropImageArray.count
            
        case detailMovieView.castCollectionView:
            return viewModel.castArray.count
            
        case detailMovieView.posterCollectionView:
            return viewModel.posterImageArray.count
            
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
            
            cell.configureCell(viewModel.backdropImageArray[indexPath.item])
            return cell
            
        case detailMovieView.castCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CastCollectionViewCell.identifier,
                for: indexPath
            ) as? CastCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configureCell(viewModel.castArray[indexPath.item])
            return cell
            
        case detailMovieView.posterCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PosterCollectionViewCell.identifier,
                for: indexPath
            ) as? PosterCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configureCell(viewModel.posterImageArray[indexPath.item])
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
