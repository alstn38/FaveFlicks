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
    
    func presentAlertWithCancel(title: String, message: String, handler: @escaping () -> Void) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let confirmAlertAction = UIAlertAction(
            title: StringLiterals.Alert.confirm,
            style: .destructive
        ) { _ in
            handler()
        }
        
        let cancelAlertAction = UIAlertAction(
            title: StringLiterals.Alert.cancel,
            style: .cancel
        )
        
        alertController.addAction(confirmAlertAction)
        alertController.addAction(cancelAlertAction)
        present(alertController, animated: true)
    }
}
