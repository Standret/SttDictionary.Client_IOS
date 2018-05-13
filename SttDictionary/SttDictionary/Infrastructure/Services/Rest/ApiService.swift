//
//  ApiService.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import KeychainSwift

protocol IApiService {
    func inserToken(token: String)
}

class ApiService: IApiService {
    
    var _httpService: IHttpService!
    
    init() {
        //  ServiceInjectorAssembly.instance().inject(into: self)
        _httpService.url = Constants.apiUrl
        _httpService.token = KeychainSwift().get(Constants.tokenKey)
    }
    
    func inserToken(token: String) {
        _httpService.token = token
    }
    
    
}
