//
//  ServiceInjectorAssembly.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import EasyDi

class ServiceInjectorAssembly: Assembly {
    
    lazy var serviceAssembly: ServiceAssembly = self.context.assembly()
    
    // Inject into providers
    
    func inject(into service: ApiDataProvider) {
        let _:ApiDataProvider = define(init: service) {
            $0._httpService = self.serviceAssembly.httpService
            return $0
        }
    }
    
    // Inject into repositories
    
    func inject(into service: WordRepositories) {
        let _:WordRepositories = define(init: service) {
            $0._apiDataProvider = self.serviceAssembly.apiDataProvider
            $0._storageProvider = self.serviceAssembly.realmStorageProvider
            return $0
        }
    }
    func inject(into service: StatisticsRepositories) {
        let _:StatisticsRepositories = define(init: service) {
            $0._apiDataProvider = self.serviceAssembly.apiDataProvider
            $0._storageProvider = self.serviceAssembly.realmStorageProvider
            return $0
        }
    }
    func inject(into service: TagRepositories) {
        let _:TagRepositories = define(init: service) {
            $0._apiDataProvider = self.serviceAssembly.apiDataProvider
            $0._storageProvider = self.serviceAssembly.realmStorageProvider
            return $0
        }
    }
    func inject(into service: AnswerRepositories) {
        let _:AnswerRepositories = define(init: service) {
            $0._apiDataProvider = self.serviceAssembly.apiDataProvider
            $0._storageProvider = self.serviceAssembly.realmStorageProvider
            return $0
        }
    }
    
    // Inject into interactors
    
    func inject(into service: WordInteractor) {
        let _:WordInteractor = define(init: service) {
            $0._wordRepositories = self.serviceAssembly.wordRepositories
            $0._notificationError = self.serviceAssembly.notificationError
            $0._answerRepositories = self.serviceAssembly.answerRepositories
            $0._statisticsRepositories = self.serviceAssembly.statisticsRepositories
            $0._smEngine = self.serviceAssembly.smEngine
            return $0
        }
    }
    
    func inject(into service: SyncInteractor) {
        let _:SyncInteractor = define(init: service) {
            $0._wordRepositories = self.serviceAssembly.wordRepositories
            $0._notificationError = self.serviceAssembly.notificationError
            $0._statisticsRepositories = self.serviceAssembly.statisticsRepositories
            $0._tagRepositories = self.serviceAssembly.tagRepositories
            $0._answerRepositories = self.serviceAssembly.answerRepositories
            return $0
        }
    }
    
    func inject(into service: StudyInteractor) {
        let _:StudyInteractor = define(init: service) {
            $0._wordRepositories = self.serviceAssembly.wordRepositories
            $0._notificationError = self.serviceAssembly.notificationError
            $0._statisticsRepositories = self.serviceAssembly.statisticsRepositories
            $0._answersRepositories = self.serviceAssembly.answerRepositories
            return $0
        }
    }
    
    // Inject service into presenter
    
    func inject(into service: NewWordPresenter) {
        let _:NewWordPresenter = define(init: service) {
            $0._wordInteractor = self.serviceAssembly.wordInteractor
            return $0
        }
    }
    
    func inject(into service: SyncPresenter) {
        let _:SyncPresenter = define(init: service) {
            $0._syncInteractor = self.serviceAssembly.syncInteractor
            return $0
        }
    }
    
    func inject(into service: StudyPresenter) {
        let _:StudyPresenter = define(init: service) {
            $0._studyInteractor = self.serviceAssembly.studyInteractor
            return $0
        }
    }
    
    func inject(into service: WordPresenter) {
        let _:WordPresenter = define(init: service) {
            $0._wordInteractor = self.serviceAssembly.wordInteractor
            return $0
        }
    }
    
    func inject(into service: CardsPresenter) {
        let _:CardsPresenter = define(init: service) {
            $0._wordInteractor = self.serviceAssembly.wordInteractor
            return $0
        }
    }
    
    func inject(into service: SearchLinkedWordsPresenter) {
        let _:SearchLinkedWordsPresenter = define(init: service) {
            $0._wordInteractor = self.serviceAssembly.wordInteractor
            return $0
        }
    }
    
    func inject<T>(into service: SttPresenter<T>) {
        let _:SttPresenter<T> = define(init: service) {
            $0._notificationError = self.serviceAssembly.notificationError
            return $0
        }
    }
    
   //  Inject Service into service
    
    
    func inject(into service: SyncService) {
        let _:SyncService = define(init: service) {
            $0._unitOfWork = self.serviceAssembly.realmStorageProvider
            $0._apiServicce = self.serviceAssembly.apiDataProvider
            $0._notificationError = self.serviceAssembly.notificationError
            return $0
        }
    }
    
    func inject(into service: WordServie) {
        let _:WordServie = define(init: service) {
            $0._unitOfWork = self.serviceAssembly.realmStorageProvider
            $0._notificationError = self.serviceAssembly.notificationError
            $0._smEngine = self.serviceAssembly.smEngine
            return $0
        }
    }
}
