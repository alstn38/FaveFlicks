//
//  ProfileImageViewModel.swift
//  FaveFlicks
//
//  Created by 강민수 on 2/9/25.
//

import Foundation

final class ProfileImageViewModel: InputOutputModel {
    
    struct Input {
        let profileImageDidSelect: CurrentValueRelay<Int>
    }
    
    struct Output {
        let profileImageIndex: BehaviorSubject<(past: Int, current: Int)>
    }
    
    let isEditMode: Bool
    let profileImageManager = ProfileImageManager()
    private var selectedProfileImageIndex: Int
    
    init(selectedProfileImageIndex: Int, isEditMode: Bool) {
        self.selectedProfileImageIndex = selectedProfileImageIndex
        self.isEditMode = isEditMode
    }
    
    func transform(from input: Input) -> Output {
        let output = Output(profileImageIndex: BehaviorSubject((0, selectedProfileImageIndex)))
        
        input.profileImageDidSelect.bind { [weak self] index in
            guard let self else { return }
            let pastIndex = selectedProfileImageIndex
            selectedProfileImageIndex = index
            output.profileImageIndex.send((pastIndex, index))
        }
        
        return output
    }
}
