//
//  ErrorModel.swift
//  SttDictionary
//
//  Created by Standret on 14.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

enum ReaalmError: Error {
    case objectIsSignleton
    case notFoundObjects
    case queryIsNull
    case doenotExactlyQuery
    
    func getMessage() -> String {
        var result: String!
        switch self {
        case .objectIsSignleton:
            result = "object is singleton"
        case .notFoundObjects:
            result = "not found objects"
        case .queryIsNull:
            result = "quert is null"
        case .doenotExactlyQuery:
            result = "query found more than one object or does not found anything"
        default:
            result = "unkown error"
        }
        
        return result
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
