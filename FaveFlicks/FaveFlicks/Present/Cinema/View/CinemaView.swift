//
//  CinemaView.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/25/25.
//

import SnapKit
import UIKit

final class CinemaView: UIView {
    
    let userInfoView = UserInfoView()
    
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
            userInfoView
        )
    }
    
    private func configureLayout() {
        userInfoView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(15)
            $0.centerX.equalToSuperview()
        }
    }
}
