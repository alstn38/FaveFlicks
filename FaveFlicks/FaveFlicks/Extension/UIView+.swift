//
//  UIView+.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/24/25.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
