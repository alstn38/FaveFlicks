//
//  ProfileView.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/24/25.
//

import SnapKit
import UIKit

final class ProfileView: UIView {
    
    var image: UIImage? = nil {
        didSet {
            profileImageView.image = image
        }
    }
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor(resource: .faveFlicsMain).cgColor
        imageView.layer.masksToBounds = true
        return imageView
    }()

    init(size: CGFloat) {
        super.init(frame: .zero)
        configureView(size: size)
        configureHierarchy()
        configureLayout(size: size)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.alpha = 1.0
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear) {
                self.alpha = 0.5
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.alpha = 0.5
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear) {
                self.alpha = 1.0
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.alpha = 0.5
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear) {
                self.alpha = 1.0
            }
        }
    }
    
    private func configureView(size: CGFloat) {
        profileImageView.layer.cornerRadius = size / 2
    }
    
    private func configureHierarchy() {
        addSubviews(
            profileImageView
        )
    }
    
    private func configureLayout(size: CGFloat) {
        self.snp.makeConstraints {
            $0.size.equalTo(size)
        }
        
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
