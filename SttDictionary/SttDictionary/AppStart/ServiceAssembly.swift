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
    var statisticsRepositories: StatisticsRepositoriesType {
        return define(scope: .lazySingleton, init: StatisticsRepositories())
    }
    var answerRepositories: AnswerRepositoriesType {
        return define(scope: .lazySingleton, init: AnswerRepositories())
    }
    var tagRepositories: TagRepositoriesType {
        return define(scope: .lazySingleton, init: TagRepositories())
    }
    
    // interactors
    var wordInteractor: WordInteractorType {
        return define(scope: .lazySingleton, init: WordInteractor())
    }
    var syncInteractor: SyncInteractorType {
        return define(scope: .lazySingleton, init: SyncInteractor())
    }
    
    // services
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
