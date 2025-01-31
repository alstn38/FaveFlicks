//
//  UpComingViewController.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/25/25.
//

import UIKit

final class UpComingViewController: UIViewController {
    
    private let upComingView = UpComingView()
    
    override func loadView() {
        view = upComingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
    }
    
    private func configureNavigation() {
        navigationItem.title = StringLiterals.UpComing.title
    }
}
