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
        imageView.image = ProfileImageManager().getCurrentProfileImage()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 25
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
        label.textColor = UIColor(resource: .faveFlicksGray)
        label.numberOfLines = 1
        return label
    }()
    
    private let rightChevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(resource: .faveFlicksGray)
        return imageView
    }()
    
    private let movieBoxBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .faveFlicsMain)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    private let movieBoxCountLabel: UILabel = {
        let label = UILabel()
        let favoriteMovieCount = UserDefaultManager.shared.favoriteMovieDictionary.keys.count
        label.text = "\(favoriteMovieCount)" + StringLiterals.Cinema.movieBoxCount
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor(resource: .faveFlicksWhite)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        configureView()
        configureHierarchy()
        configureLayout()
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
    
    func updateUserInfo() {
        profileImageView.image = ProfileImageManager().getCurrentProfileImage()
        nickNameLabel.text = UserDefaultManager.shared.nickName
        joinDateLabel.text = UserDefaultManager.shared.joinDate
        
        let favoriteMovieCount = UserDefaultManager.shared.favoriteMovieDictionary.keys.count
        movieBoxCountLabel.text = "\(favoriteMovieCount)" + StringLiterals.Cinema.movieBoxCount
    }
         
    private func configureView() {
        self.layer.cornerRadius = 20
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor(resource: .faveFlicksGray).withAlphaComponent(0.5)
    }
    
    private func configureHierarchy() {
        addSubviews(
            profileImageView,
            nickNameLabel,
            joinDateLabel,
            rightChevronImageView,
            movieBoxBackgroundView,
            movieBoxCountLabel
        )
    }
    
    private func configureLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width - 30)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.leading.equalTo(safeAreaLayoutGuide).offset(15)
            $0.size.equalTo(50)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
            $0.trailing.equalTo(rightChevronImageView.snp.leading).inset(15)
            $0.bottom.equalTo(profileImageView.snp.centerY)
        }
        
        joinDateLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.centerY).offset(5)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
            $0.trailing.equalTo(rightChevronImageView.snp.leading).inset(15)
        }
        
        rightChevronImageView.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(15)
            $0.size.equalTo(20)
        }
        
        movieBoxBackgroundView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(15)
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(15)
            $0.height.equalTo(35)
        }
        
        movieBoxCountLabel.snp.makeConstraints {
            $0.center.equalTo(movieBoxBackgroundView)
        }
    }
}
