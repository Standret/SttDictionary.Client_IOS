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

enum ApiError: Error {
    case badRequest(String)
    case internalServerError(String)
    case unkownApiError(Int)
    case jsonConvertError
    case noInternetConnectionError
    case requestTimeoutError
    
    func getMessage() -> String {
        var result: String!
        switch self {
        case .badRequest(let message):
            result = message
        case .internalServerError(let message):
            result = message
        case .jsonConvertError:
            result = "jsonConvertError"
        case .noInternetConnectionError:
            result = "no internet connection"
        case .requestTimeoutError:
            result = "request timeout"
        default:
            result = "unkown error"
        }
        
        return result
    }
}
