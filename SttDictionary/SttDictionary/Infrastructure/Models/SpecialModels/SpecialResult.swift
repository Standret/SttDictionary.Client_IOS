//
//  ApiSpecial.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

class ResultModel<TResult> {
    let isSuccess: Bool
    let isLocal: Bool
    let result: TResult?
    let error: ApiError?
    
    convenience init(result: TResult, isLocal: Bool) {
        self.init(isSuccess: true, isLocal: isLocal, result: result, error: nil)
    }
    
    convenience init(error: ApiError) {
        self.init(isSuccess: false, isLocal: true, result: nil, error: error)
    }
    
    private init(isSuccess: Bool, isLocal: Bool, result: TResult?, error: ApiError?) {
        self.isSuccess = isSuccess
        self.isLocal = isLocal
        self.result = result
        self.error = error
    }
}
