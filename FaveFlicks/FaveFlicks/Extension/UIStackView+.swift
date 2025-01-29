//
//  UIStackView+.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/29/25.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}
