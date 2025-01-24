//
//  OnboardingView.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/24/25.
//

import SnapKit
import UIKit

final class OnboardingView: UIView {
    
    private let onboardingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .onboarding)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let onboardingTitleLabel: UILabel = {
        let label = UILabel()
        label.text = StringLiterals.Onboarding.title
        label.textColor = UIColor(resource: .faveFlicksWhite)
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let onboardingSubTitleLabel: UILabel = {
        let label = UILabel()
        label.text = StringLiterals.Onboarding.subTitle
        label.textColor = UIColor(resource: .faveFlicksWhite)
        label.font = .boldSystemFont(ofSize: 13)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let startButton: UIButton = {
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = AttributedString(StringLiterals.Onboarding.startButtonTitle, attributes: titleContainer)
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
    
    private func configureView() {
        backgroundColor = UIColor(resource: .faveFlicksBlack)
    }
    
    private func configureHierarchy() {
        addSubviews(
            onboardingImageView,
            onboardingTitleLabel,
            onboardingSubTitleLabel,
            startButton
        )
    }
    
    private func configureLayout() {
        onboardingImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(15)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(onboardingImageView.snp.width).multipliedBy(4/3)
        }
        
        onboardingTitleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(onboardingSubTitleLabel.snp.top).offset(-30)
        }
        
        onboardingSubTitleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(startButton.snp.top).offset(-30)
        }
        
        startButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(15)
            $0.height.equalTo(38)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-50)
        }
    }
}

