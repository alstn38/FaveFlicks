//
//  UserDefault.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/25/25.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    private let key: String
    private let defaultValue: T
    
    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: self.key) as? T ?? self.defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: self.key) }
    }
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
