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
    
    @objc private func favoriteButtonDidTap(_ sender: UIBarButtonItem) {
        
    }
}
