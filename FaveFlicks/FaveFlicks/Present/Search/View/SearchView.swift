//
//  SearchView.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/28/25.
//

import SnapKit
import UIKit

final class SearchView: UIView {
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.leftView?.tintColor = UIColor(resource: .faveFlicksLightGray)
        searchBar.searchTextField.backgroundColor = UIColor(resource: .faveFlicksBlack)
        searchBar.backgroundColor = UIColor(resource: .faveFlicksBlack)
        searchBar.barTintColor = UIColor(resource: .faveFlicksBlack)
        searchBar.tintColor = UIColor(resource: .faveFlicksWhite)
        searchBar.searchTextField.textColor = UIColor(resource: .faveFlicksWhite)
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: StringLiterals.Search.searchPlaceholder,
            attributes: [NSAttributedString.Key.foregroundColor : UIColor(resource: .faveFlicksGray)]
        )
        return searchBar
    }()
    
    let noSearchResultLabel: UILabel = {
        let label = UILabel()
        label.text = StringLiterals.Search.noResultText
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(resource: .faveFlicksGray)
        return label
    }()
    
    let searchCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let sectionInset: CGFloat = 15
        let width: CGFloat = UIScreen.main.bounds.width
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = .zero
        layout.sectionInset = UIEdgeInsets(top: sectionInset, left: 0, bottom: sectionInset, right: 0)
        layout.estimatedItemSize = CGSize(width: width, height: 150)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
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
            searchBar,
            noSearchResultLabel,
            searchCollectionView
        )
    }
    
    private func configureLayout() {
        searchBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        noSearchResultLabel.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(200)
            $0.centerX.equalToSuperview()
        }
        
        searchCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
