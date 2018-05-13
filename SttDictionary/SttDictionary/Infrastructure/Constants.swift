//
//  Constants.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

enum ApiConroller {
    case token
    case users(String)
    
    func get() -> String {
        switch self {
        case .token:
            return "/api/token"
        case .users(let method):
            return "\(Constants.versionApi)users/\(method)"
        }
    }
}

class Constants {
    // url
    static var apiUrl = "https://qa-startupsoft-imx.azurewebsites.net/"
    static var blobUrl = "https://prodssanalyticsstorage.blob.core.windows.net"
    static var versionApi = "/api/"
    
    // keychain id
    static var tokenKey = "securityAccessToken"
    static var idKey = "securityUserId"
    
    // api config
    static var maxImageCacheSize = 1024 * 1024 * 200
    static var maxCacheAge = 60 * 60 * 24 * 7 * 4
    static var timeout = TimeInterval(15) + TimeInterval(timeWaitNextRequest)
    static var timeWaitNextRequest = UInt32(2)
    static var maxCountRepeatRequest = 3
    
    // error string
    static var incorrectLogin = "Email or Password is incorrect."
    
    // image key
    static var avatarPlaceholder = "avatarPlaceholder"
}
