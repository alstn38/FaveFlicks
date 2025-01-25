//
//  FaveFlicksTabBarController.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/25/25.
//

import UIKit

final class FaveFlicksTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(resource: .faveFlicksBlack)
        configureTabBarController()
        configureTabBarAppearance()
    }
    
    private func configureTabBarController() {
        let cinemaViewController = CinemaViewController()
        cinemaViewController.tabBarItem = UITabBarItem(
            title: StringLiterals.TapBar.cinemaTitle,
            image: UIImage(systemName: "popcorn"),
            selectedImage: UIImage(systemName: "popcorn")
        )
        
        let upComingViewController = UpComingViewController()
        upComingViewController.tabBarItem = UITabBarItem(
            title: StringLiterals.TapBar.upComingTitle,
            image: UIImage(systemName: "film.stack"),
            selectedImage: UIImage(systemName: "film.stack")
        )
        
        let settingViewController = SettingViewController()
        settingViewController.tabBarItem = UITabBarItem(
            title: StringLiterals.TapBar.settingTitle,
            image: UIImage(systemName: "person.crop.circle"),
            selectedImage: UIImage(systemName: "person.crop.circle")
        )
        
        let cinemaNavigationController = UINavigationController(rootViewController: cinemaViewController)
        let upComingNavigationController = UINavigationController(rootViewController: upComingViewController)
        let settingNavigationController = UINavigationController(rootViewController: settingViewController)
        setViewControllers(
            [cinemaNavigationController, upComingNavigationController, settingNavigationController],
            animated: true
        )
    }
    
    private func configureTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(resource: .faveFlicksBlack)
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor(resource: .faveFlicksGray)
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(resource: .faveFlicsMain)
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
        tabBar.tintColor = UIColor(resource: .faveFlicsMain)
    }
}
