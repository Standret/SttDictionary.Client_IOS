//
//  Constants.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

enum ApiConroller {
    case word(String), tag(String)
    
    func get() -> String {
        var data: (String, String)!
        switch self {
        case .word(let method):
            data = ("word", method)
        case .tag(let method):
            data = ("tag", method)
        }
        
        return "\(Constants.versionApi)\(data.0)/\(data.1)"
    }
}

class Constants {
    // url
    static let apiUrl = "http://192.168.0.66:8080"
    static let versionApi = "/api/v1/"
    
    // keychain id
    static let tokenKey = "securityAccessToken"
    static let idKey = "securityUserId"
    
    // api config
    static let maxImageCacheSize = 1024 * 1024 * 200
    static let maxCacheAge = 60 * 60 * 24 * 7 * 4
    static let timeout = TimeInterval(15) + TimeInterval(timeWaitNextRequest)
    static let timeWaitNextRequest = UInt32(2)
    static let maxCountRepeatRequest = 3
    
    // realm
    static let keySingle = "--single--"
    
    // log - key
    static let httpKeyLog = "HTTP"
    static let apiDataKeyLog = "APIDP"
    static let repositoryLog = "RealmRep"
    static let repositoryExtensionsLog = "RealmEXTRep"
    static let noImplementException = "No implement exception"
    
    // SM
    
    static let countOfNewCard = 15
    static let countCardsPerSession = 7
    static let minCardsPerSession = 5
}
