//
//  BackdropCollectionViewCell.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/29/25.
//

import Kingfisher
import SnapKit
import UIKit

final class BackdropCollectionViewCell: UICollectionViewCell {
    
    private let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(_ detailImage: DetailImage) {
        let url = URL(string: Secret.imageURL + detailImage.filePath)
        backdropImageView.kf.setImage(with: url)
    }
    
    private func configureHierarchy() {
        addSubview(backdropImageView)
    }
    
    private func configureLayout() {
        backdropImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
