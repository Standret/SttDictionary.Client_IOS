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
    static var apiUrl = "http://192.168.0.66:8080"
    static var versionApi = "/api/v1/"
    
    // keychain id
    static var tokenKey = "securityAccessToken"
    static var idKey = "securityUserId"
    
    // api config
    static var maxImageCacheSize = 1024 * 1024 * 200
    static var maxCacheAge = 60 * 60 * 24 * 7 * 4
    static var timeout = TimeInterval(15) + TimeInterval(timeWaitNextRequest)
    static var timeWaitNextRequest = UInt32(2)
    static var maxCountRepeatRequest = 3
    
    // realm
    static var keySingle = "--single--"
    
    // log - key
    static var httpKeyLog = "HTTP"
    static var apiDataKeyLog = "APIDP"
    static var repositoryLog = "RealmRep"
    static var repositoryExtensionsLog = "RealmEXTRep"
    static var noImplementException = "No implement exception"
}
