//
//  ApiSpecial.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

class SttResultModel<TResult> {
    let isLocal: Bool
    let result: TResult
    
    convenience init(result: TResult, isLocal: Bool) {
        self.init(isLocal: isLocal, result: result)
    }
    
    private init(isLocal: Bool, result: TResult) {
        self.isLocal = isLocal
        self.result = result
    }
}
