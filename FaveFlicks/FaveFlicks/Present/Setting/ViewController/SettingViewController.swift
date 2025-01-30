//
//  SettingViewController.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/25/25.
//

import UIKit

final class SettingViewController: UIViewController {
    
    private let settingView = SettingView()
    private let settingTitleArray: [String] = [
        StringLiterals.Setting.frequentlyAskedQuestions,
        StringLiterals.Setting.oneOnoneInquiry,
        StringLiterals.Setting.setNotifications,
        StringLiterals.Setting.deleteAccount
    ]
    
    override func loadView() {
        view = settingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureCollectionView()
    }
    
    private func configureNavigation() {
        navigationItem.title = StringLiterals.Setting.title
    }
    
    private func configureCollectionView() {
        settingView.settingCollectionView.delegate = self
        settingView.settingCollectionView.dataSource = self
        settingView.settingCollectionView.register(
            SettingCollectionViewCell.self,
            forCellWithReuseIdentifier: SettingCollectionViewCell.identifier
        )
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settingTitleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SettingCollectionViewCell.identifier,
            for: indexPath
        ) as? SettingCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureCell(settingTitleArray[indexPath.item])
        return cell
    }
}
