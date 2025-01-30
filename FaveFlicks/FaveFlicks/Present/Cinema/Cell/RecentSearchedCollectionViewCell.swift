//
//  RecentSearchedCollectionViewCell.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/27/25.
//

import SnapKit
import UIKit

final class RecentSearchedCollectionViewCell: UICollectionViewCell {
    
    private let roundBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor(resource: .faveFlicksWhite)
        return view
    }()
    
    private let recentSearchedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(resource: .faveFlicksBlack)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    let deleteButton: UIButton = {
        var imageConfiguration = UIImage.SymbolConfiguration(pointSize: 8)
        var configuration = UIButton.Configuration.plain()
        configuration.preferredSymbolConfigurationForImage = imageConfiguration
        configuration.image = UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))
        configuration.baseForegroundColor = UIColor(resource: .faveFlicksBlack)
        
        let button = UIButton(configuration: configuration)
        return button
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
    
    func configureCell(_ recentSearchedText: String) {
        recentSearchedLabel.text = recentSearchedText
    }
    
    private func configureHierarchy() {
        addSubviews(
            roundBackgroundView,
            recentSearchedLabel,
            deleteButton
        )
    }
    
    private func configureLayout() {
        roundBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        recentSearchedLabel.snp.makeConstraints {
            $0.leading.equalTo(roundBackgroundView).offset(8)
            $0.centerY.equalTo(roundBackgroundView)
            $0.trailing.equalTo(deleteButton.snp.leading).offset(-5)
            $0.verticalEdges.equalTo(roundBackgroundView).inset(5)
        }
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalTo(roundBackgroundView)
            $0.size.equalTo(14)
            $0.trailing.equalTo(roundBackgroundView).inset(8)
        }
    }
}
