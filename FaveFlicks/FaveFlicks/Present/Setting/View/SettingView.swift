//
//  SettingView.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/30/25.
//

import SnapKit
import UIKit

final class SettingView: UIView {
    
    let userInfoView = UserInfoView()
    
    let settingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let sectionInset: CGFloat = 10
        let width: CGFloat = UIScreen.main.bounds.width
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = .zero
        layout.minimumLineSpacing = .zero
        layout.sectionInset = UIEdgeInsets(top: sectionInset, left: 0, bottom: sectionInset, right: 0)
        layout.itemSize = CGSize(width: width, height: 50)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(resource: .faveFlicksBlack)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = UIColor(resource: .faveFlicksBlack)
    }
    
    private func configureHierarchy() {
        addSubviews(
            userInfoView,
            settingCollectionView
        )
    }
    
    private func configureLayout() {
        userInfoView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        settingCollectionView.snp.makeConstraints {
            $0.top.equalTo(userInfoView.snp.bottom).offset(5)
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}

