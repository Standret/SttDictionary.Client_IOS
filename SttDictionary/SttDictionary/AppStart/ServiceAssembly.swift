//
//  ServiceAssembly.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import EasyDi

class ServiceAssembly: Assembly {    
    var apiService: IApiService {
        return define(scope: .lazySingleton, init: FakeApiService())
    }
    var httpService: IHttpService {
        return define(scope: .lazySingleton, init: HttpService())
    }
}
