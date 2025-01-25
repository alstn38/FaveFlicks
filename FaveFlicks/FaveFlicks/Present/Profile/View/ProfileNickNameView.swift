//
//  ProfileNickNameView.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/24/25.
//

import SnapKit
import UIKit

final class ProfileNickNameView: UIView {
    
    let profileImageView: ProfileView = {
        let imageView = ProfileView(size: 100)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let profileImageButton: UIButton = {
        var imageConfiguration = UIImage.SymbolConfiguration(pointSize: 10)
        var configuration = UIButton.Configuration.filled()
        configuration.preferredSymbolConfigurationForImage = imageConfiguration
        configuration.image = UIImage(systemName: "camera.fill")
        configuration.baseBackgroundColor = UIColor(resource: .faveFlicsMain)
        configuration.baseForegroundColor = UIColor(resource: .faveFlicksWhite)
        
        let button = UIButton(configuration: configuration)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()
    
    let nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.font = .systemFont(ofSize: 13, weight: .medium)
        textField.attributedPlaceholder = NSAttributedString(
            string: StringLiterals.ProfileNickName.nickNamePlaceholder,
            attributes: [NSAttributedString.Key.foregroundColor : UIColor(resource: .faveFlicksGray)]
        )
        textField.textColor = UIColor(resource: .faveFlicksWhite)
        textField.tintColor = UIColor(resource: .faveFlicksWhite)
        return textField
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .faveFlicksWhite)
        return view
    }()
    
    private let nickNameStatusLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .faveFlicsMain)
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    let confirmButton: UIButton = {
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = AttributedString(StringLiterals.ProfileNickName.confirmButtonTitle, attributes: titleContainer)
        configuration.baseBackgroundColor = UIColor(resource: .faveFlicksBlack)
        configuration.baseForegroundColor = UIColor(resource: .faveFlicsMain)
        
        let button = UIButton(configuration: configuration)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(resource: .faveFlicsMain).cgColor
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(image: UIImage) {
        profileImageView.image = image
    }
    
    func configureNickNameStatus(_ status: NickNameStatus) {
        nickNameStatusLabel.text = status.description
    }
    
    private func configureView() {
        backgroundColor = UIColor(resource: .faveFlicksBlack)
    }
    
    private func configureHierarchy() {
        addSubviews(
            profileImageView,
            profileImageButton,
            nickNameTextField,
            lineView,
            nickNameStatusLabel,
            confirmButton
        )
    }
    
    private func configureLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        profileImageButton.snp.makeConstraints {
            $0.bottom.trailing.equalTo(profileImageView)
            $0.size.equalTo(30)
        }
        
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(30)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(10)
            $0.height.equalTo(1)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(15)
        }
        
        nickNameStatusLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(15)
            $0.height.equalTo(15)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(nickNameStatusLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(15)
            $0.height.equalTo(38)
        }
    }
}

// MARK: - NickNameStatus
extension ProfileNickNameView {
    
    enum NickNameStatus {
        case empty
        case possible
        case invalidRange
        case hasSectionSign
        case hasNumber
        
        var description: String? {
            switch self {
            case .empty:
                return nil
            case .possible:
                return StringLiterals.ProfileNickName.possibleStatus
            case .invalidRange:
                return StringLiterals.ProfileNickName.invalidRangeStatus
            case .hasSectionSign:
                return StringLiterals.ProfileNickName.hasSectionSignStatus
            case .hasNumber:
                return StringLiterals.ProfileNickName.hasNumberStatus
            }
        }
    }
}
