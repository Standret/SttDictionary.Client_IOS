//
//  BaseConverter.swift
//  SttDictionary
//
//  Created by Standret on 21.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol IConverter {
    associatedtype TIn
    associatedtype TOut
    
    func convert(value: TIn, parametr: Any?) -> TOut
}

extension IConverter {
    func convert(value: TIn) -> TOut {
        return self.convert(value: value, parametr: nil)
    }
}
