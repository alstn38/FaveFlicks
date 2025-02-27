//
//  SceneDelegate.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/24/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let viewController = configureInitViewController()
        window = UIWindow(windowScene: scene)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
    
    private func configureInitViewController() -> UIViewController {
        
        switch UserDefaultManager.shared.hasProfile {
        case true:
            return FaveFlicksTabBarController()
        case false:
            return UINavigationController(rootViewController: OnboardingViewController())
        }
    }
}
