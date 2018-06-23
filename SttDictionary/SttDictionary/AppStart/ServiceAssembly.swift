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
        return define(scope: .lazySingleton, init: ApiService())
    }
    var httpService: SttHttpServiceType {
        return define(scope: .lazySingleton, init: SttHttpService())
    }
    var unitOfWork: UnitOfWorkType {
        return define(scope: .lazySingleton, init: UnitOfWork())
    }
    var syncService: ISyncService {
        return define(scope: .lazySingleton, init: SyncService())
    }
    var wordService: IWordService {
        return define(scope: .lazySingleton, init: WordServie())
    }
    var notificationError: NotificationErrorType {
        return define(scope: .lazySingleton, init: NotificationError())
    }
    var smEngine: SMEngine {
        return define(scope: .lazySingleton, init: SM2Engine())
    }
}
