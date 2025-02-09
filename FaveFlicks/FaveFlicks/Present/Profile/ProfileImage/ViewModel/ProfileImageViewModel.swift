//
//  ProfileImageViewModel.swift
//  FaveFlicks
//
//  Created by 강민수 on 2/9/25.
//

import Foundation

final class ProfileImageViewModel {
    
    struct Input {
        let profileImageDidSelect: CurrentValueRelay<Int>
    }
    
    struct Output {
        let profileImageIndex: BehaviorSubject<(past: Int, current: Int)>
    }
    
    private let profileImageIndexSubject: BehaviorSubject<(past: Int, current: Int)>
    
    let isEditMode: Bool
    let profileImageManager = ProfileImageManager()
    
    init(selectedProfileImageIndex: Int, isEditMode: Bool) {
        self.profileImageIndexSubject = BehaviorSubject((0, selectedProfileImageIndex))
        self.isEditMode = isEditMode
    }
    
    func transform(from input: Input) -> Output {
        input.profileImageDidSelect.bind { [weak self] index in
            guard let self else { return }
            let pastIndex = profileImageIndexSubject.value.current
            profileImageIndexSubject.send((pastIndex, index))
        }
        
        return Output(profileImageIndex: profileImageIndexSubject)
    }
}
