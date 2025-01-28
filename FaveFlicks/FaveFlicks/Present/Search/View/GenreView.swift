//
//  GenreView.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/28/25.
//

import SnapKit
import UIKit

final class GenreView: UIView {
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(resource: .faveFlicksWhite)
        return label
    }()
    
    init(genre: Int) {
        super.init(frame: .zero)
        
        genreLabel.text = GenreType(num: genre).description
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = UIColor(resource: .faveFlicksWhite).withAlphaComponent(0.3)
        layer.cornerRadius = 5
        clipsToBounds = true
    }
    
    private func configureHierarchy() {
        addSubview(genreLabel)
    }
    
    private func configureLayout() {
        genreLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
    }
}

// MARK: - GenreType
extension GenreView {
    
    enum GenreType {
        case action
        case animation
        case crime
        case drama
        case fantasy
        case horror
        case mystery
        case scienceFiction
        case thriller
        case western
        case adventure
        case comedy
        case documentary
        case family
        case history
        case music
        case romance
        case tvMovie
        case war
        case none
        
        init(num: Int) {
            switch num {
            case 28:
                self = .action
            case 16:
                self = .animation
            case 80:
                self = .crime
            case 18:
                self = .drama
            case 14:
                self = .fantasy
            case 27:
                self = .horror
            case 9648:
                self = .mystery
            case 878:
                self = .scienceFiction
            case 53:
                self = .thriller
            case 37:
                self = .western
            case 12:
                self = .adventure
            case 35:
                self = .comedy
            case 99:
                self = .documentary
            case 10751:
                self = .family
            case 36:
                self = .history
            case 10402:
                self = .music
            case 10749:
                self = .romance
            case 10770:
                self = .tvMovie
            case 10752:
                self = .war
            default:
                self = .none
            }
        }
        
        var description: String {
            switch self {
            case .action:
                return "액션"
            case .animation:
                return "애니메이션"
            case .crime:
                return "범죄"
            case .drama:
                return "드라마"
            case .fantasy:
                return "판타지"
            case .horror:
                return "공포"
            case .mystery:
                return "미스터리"
            case .scienceFiction:
                return "SF"
            case .thriller:
                return "스릴러"
            case .western:
                return "서부"
            case .adventure:
                return "모험"
            case .comedy:
                return "코미디"
            case .documentary:
                return "다큐멘터리"
            case .family:
                return "가족"
            case .history:
                return "역사"
            case .music:
                return "음악"
            case .romance:
                return "로맨스"
            case .tvMovie:
                return "TV 영화"
            case .war:
                return "전쟁"
            case .none:
                return "알수없음"
            }
        }
    }
}
