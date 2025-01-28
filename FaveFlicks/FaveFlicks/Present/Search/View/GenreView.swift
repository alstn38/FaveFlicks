//
//  GenreView.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/28/25.
//

import SnapKit
import UIKit

final class GenreView: UIView {
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(resource: .faveFlicksWhite)
        return label
    }()
    
    init(genre: String) {
        super.init(frame: .zero)
        
        genreLabel.text = genre
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = UIColor(resource: .faveFlicksGray)
        layer.cornerRadius = 5
        clipsToBounds = true
    }
    
    private func configureHierarchy() {
        addSubview(genreLabel)
    }
    
    private func configureLayout() {
        genreLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
    }
}
