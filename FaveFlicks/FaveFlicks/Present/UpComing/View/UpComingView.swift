//
//  UpComingView.swift
//  FaveFlicks
//
//  Created by 강민수 on 2/1/25.
//

import SnapKit
import UIKit

final class UpComingView: UIView {
    
    private let upComingGuideLabel: UILabel = {
        let label = UILabel()
        label.text = StringLiterals.UpComing.upComingGuideText
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(resource: .faveFlicksGray)
        label.textAlignment = .center
        return label
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
        addSubview(upComingGuideLabel)
    }
    
    private func configureLayout() {
        upComingGuideLabel.snp.makeConstraints {
            $0.center.equalTo(safeAreaLayoutGuide)
        }
    }
}
