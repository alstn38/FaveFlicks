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
    
    private let mbtiTitleLabel: UILabel = {
        let label = UILabel()
        label.text = StringLiterals.ProfileNickName.mbtiTitleText
        label.textColor = UIColor(resource: .faveFlicksWhite)
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    lazy var extraversionButton = makeMBTIButton(type: .extraversion)
    lazy var introversionButton = makeMBTIButton(type: .introversion)
    lazy var sensingButton = makeMBTIButton(type: .sensing)
    lazy var intuitionButton = makeMBTIButton(type: .intuition)
    lazy var thinkingButton = makeMBTIButton(type: .thinking)
    lazy var feelingButton = makeMBTIButton(type: .feeling)
    lazy var judgingButton = makeMBTIButton(type: .judging)
    lazy var perceivingButton = makeMBTIButton(type: .perceiving)
    
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
    
    func configureView(image: UIImage?) {
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
            mbtiTitleLabel,
            extraversionButton,
            introversionButton,
            sensingButton,
            intuitionButton,
            thinkingButton,
            feelingButton,
            judgingButton,
            perceivingButton,
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
        
        mbtiTitleLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(50)
            $0.leading.equalTo(15)
        }
        
        extraversionButton.snp.makeConstraints {
            $0.top.equalTo(mbtiTitleLabel.snp.top)
            $0.trailing.equalTo(sensingButton.snp.leading).offset(-10)
            $0.size.equalTo(50)
        }
        
        introversionButton.snp.makeConstraints {
            $0.top.equalTo(extraversionButton.snp.bottom).offset(10)
            $0.trailing.equalTo(sensingButton.snp.leading).offset(-10)
            $0.size.equalTo(50)
        }
        
        sensingButton.snp.makeConstraints {
            $0.top.equalTo(mbtiTitleLabel.snp.top)
            $0.trailing.equalTo(thinkingButton.snp.leading).offset(-10)
            $0.size.equalTo(50)
        }
        
        intuitionButton.snp.makeConstraints {
            $0.top.equalTo(sensingButton.snp.bottom).offset(10)
            $0.trailing.equalTo(thinkingButton.snp.leading).offset(-10)
            $0.size.equalTo(50)
        }
        
        thinkingButton.snp.makeConstraints {
            $0.top.equalTo(mbtiTitleLabel.snp.top)
            $0.trailing.equalTo(judgingButton.snp.leading).offset(-10)
            $0.size.equalTo(50)
        }
        
        feelingButton.snp.makeConstraints {
            $0.top.equalTo(thinkingButton.snp.bottom).offset(10)
            $0.trailing.equalTo(judgingButton.snp.leading).offset(-10)
            $0.size.equalTo(50)
        }
        
        judgingButton.snp.makeConstraints {
            $0.top.equalTo(mbtiTitleLabel.snp.top)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
            $0.size.equalTo(50)
        }
        
        perceivingButton.snp.makeConstraints {
            $0.top.equalTo(judgingButton.snp.bottom).offset(10)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
            $0.size.equalTo(50)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-50)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(15)
            $0.height.equalTo(38)
        }
    }
    
    private func makeMBTIButton(type: MBTIButtonType) -> UIButton {
        let button = UIButton()
        button.setTitle(type.description, for: .normal)
        button.setTitleColor(UIColor(resource: .faveFlicksLightGray), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(resource: .faveFlicksLightGray).cgColor
        button.layer.masksToBounds = true
        return button
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
        
        var description: String {
            switch self {
            case .empty:
                return ""
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

// MARK: - MBTIType
extension ProfileNickNameView {
    
    enum MBTIButtonType: Int, CaseIterable {
        case extraversion
        case introversion
        case sensing
        case intuition
        case thinking
        case feeling
        case judging
        case perceiving
        
        var description: String {
            switch self {
            case .extraversion: return "E"
            case .introversion: return "I"
            case .sensing: return "S"
            case .intuition: return "N"
            case .thinking: return "T"
            case .feeling: return "F"
            case .judging: return "J"
            case .perceiving: return "P"
            }
        }
    }
}
