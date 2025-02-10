//
//  InputOutputModel.swift
//  FaveFlicks
//
//  Created by 강민수 on 2/10/25.
//

import Foundation

protocol InputOutputModel {
    associatedtype Input
    associatedtype Output
    
    func transform(from input: Input) -> Output
}
