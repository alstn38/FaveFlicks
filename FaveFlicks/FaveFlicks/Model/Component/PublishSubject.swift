//
//  PublishSubject.swift
//  FaveFlicks
//
//  Created by 강민수 on 2/7/25.
//

import Foundation

final class PublishSubject<T> {
    
    private var value: T {
        didSet {
            closure?(value)
        }
    }
    
    private var closure: ((T) -> Void)?
    
    init(value: T) {
        self.value = value
    }
    
    func bind(closure: @escaping (T) -> Void) {
        self.closure = closure
    }
    
    func send(_ value: T) {
        self.value = value
    }
}
