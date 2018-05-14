//
//  ApiSpecial.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

class ApiResultModel<TResult> {
    let isSuccess: Bool
    let result: TResult?
    let error: ApiError?
    
    convenience init(result: TResult) {
        self.init(isSuccess: true, result: result, error: nil)
    }
    
    convenience init(error: ApiError) {
        self.init(isSuccess: false, result: nil, error: error)
    }
    
    private init(isSuccess: Bool, result: TResult?, error: ApiError?) {
        self.isSuccess = false
        self.result = result
        self.error = error
    }
}
