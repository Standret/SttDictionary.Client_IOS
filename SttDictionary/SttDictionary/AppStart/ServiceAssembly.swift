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
    
    // modules
    var httpService: SttHttpServiceType {
        return define(scope: .lazySingleton, init: SttHttpService())
    }
    
    // providers
    var apiDataProvider: ApiDataProviderType {
        return define(scope: .lazySingleton, init: ApiDataProvider())
    }
    var realmStorageProvider: RealmStorageProviderType {
        return define(scope: .lazySingleton, init: RealmStorageProvider())
    }
    
    // repositories
    var wordRepositories: WordRepositoriesType {
        return define(scope: .lazySingleton, init: WordRepositories())
    }
    
    // services, interactors
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
