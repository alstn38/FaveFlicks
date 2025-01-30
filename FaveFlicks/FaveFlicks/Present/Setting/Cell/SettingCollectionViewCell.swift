//
//  SettingCollectionViewCell.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/30/25.
//

import SnapKit
import UIKit

final class SettingCollectionViewCell: UICollectionViewCell {
    
    private let settingTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(resource: .faveFlicksWhite)
        label.numberOfLines = 1
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .faveFlicksGray).withAlphaComponent(0.3)
        return view
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
    
    func configureCell(_ title: String) {
        settingTitleLabel.text = title
    }
    
    private func configureHierarchy() {
        addSubviews(
            settingTitleLabel,
            lineView
        )
    }
    
    private func configureLayout() {
        settingTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
        }
        
        lineView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.height.equalTo(1)
        }
    }
}

