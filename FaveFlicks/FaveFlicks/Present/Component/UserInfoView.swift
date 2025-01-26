//
//  UserInfoView.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/25/25.
//

import SnapKit
import UIKit

final class UserInfoView: UIView {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UserDefaultManager.shared.profileImage
        imageView.contentMode = .scaleToFill
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor(resource: .faveFlicsMain).cgColor
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = UserDefaultManager.shared.nickName
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(resource: .faveFlicksWhite)
        label.numberOfLines = 1
        return label
    }()
    
    private let joinDateLabel: UILabel = {
        let label = UILabel()
        label.text = UserDefaultManager.shared.joinDate
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(resource: .faveFlicksLightGray)
        label.numberOfLines = 1
        return label
    }()
    
    private let rightChevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(resource: .faveFlicksLightGray)
        return imageView
    }()
    
    private let movieBoxBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .faveFlicksGray)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let movieBoxCountLabel: UILabel = {
        let label = UILabel()
        label.text = "\(UserDefaultManager.shared.movieBoxCount)" + StringLiterals.Cinema.movieBoxCount
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(resource: .faveFlicksLightGray)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
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
