//
//  SettingViewController.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/25/25.
//

import UIKit

final class SettingViewController: UIViewController {
    
    private let settingView = SettingView()
    private let settingItemArray: [SettingItem] = SettingItem.allCases
    
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
        return settingItemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SettingCollectionViewCell.identifier,
            for: indexPath
        ) as? SettingCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureCell(settingItemArray[indexPath.item].description)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let settingItem = settingItemArray[indexPath.item]
        
        switch settingItem {
        case SettingItem.frequentlyAskedQuestions:
            return
        case SettingItem.oneOnoneInquiry:
            return
        case SettingItem.setNotifications:
            return
        case SettingItem.deleteAccount:
            presentAlertWithCancel(title: StringLiterals.Setting.deleteAlertTitle, message: StringLiterals.Setting.deleteAlertMessage) {
                guard
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let window = windowScene.windows.first
                else { return }
                
                let onboardingNavigationController = UINavigationController(rootViewController: OnboardingViewController())
                onboardingNavigationController.view.alpha = 0.5
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear) {
                    onboardingNavigationController.view.alpha = 1.0
                }
                
                UserDefaultManager.shared.deleteAccount()
                window.rootViewController = onboardingNavigationController
            }
        }
    }
}

// MARK: - SettingItem
extension SettingViewController {
    
    enum SettingItem: CaseIterable {
        case frequentlyAskedQuestions
        case oneOnoneInquiry
        case setNotifications
        case deleteAccount
        
        var description: String {
            switch self {
            case .frequentlyAskedQuestions:
                return StringLiterals.Setting.frequentlyAskedQuestions
            case .oneOnoneInquiry:
                return StringLiterals.Setting.oneOnoneInquiry
            case .setNotifications:
                return StringLiterals.Setting.setNotifications
            case .deleteAccount:
                return StringLiterals.Setting.deleteAccount
            }
        }
    }
}
