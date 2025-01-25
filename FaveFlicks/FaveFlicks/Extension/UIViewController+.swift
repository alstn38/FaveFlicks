//
//  UIViewController+.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/25/25.
//

import UIKit

extension UIViewController {
    
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let alertAction = UIAlertAction(
            title: StringLiterals.Alert.confirm,
            style: .default
        )
        
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
}
