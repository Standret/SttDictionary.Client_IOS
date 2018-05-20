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
    
    // Inject service into presenter
    
    func inject(into service: SyncPresenter) {
        let _:SyncPresenter = define(init: service) {
            $0._syncService = self.serviceAssembly.syncService
            return $0
        }
    }
    
    func inject(into service: WordPresenter) {
        let _:WordPresenter = define(init: service) {
            $0._wordService = self.serviceAssembly.wordService
            return $0
        }
    }
    
    func inject(into service: NewWordPresenter) {
        let _:NewWordPresenter = define(init: service) {
            $0._wordService = self.serviceAssembly.wordService
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
    
    func inject(into service: ApiService) {
        let _:ApiService = define(init: service) {
            $0._httpService = self.serviceAssembly.httpService
            $0._unitOfWork = self.serviceAssembly.unitOfWork
            return $0
        }
    }
    
    func inject(into service: SyncService) {
        let _:SyncService = define(init: service) {
            $0._unitOfWork = self.serviceAssembly.unitOfWork
            $0._apiServicce = self.serviceAssembly.apiService
            $0._notificationError = self.serviceAssembly.notificationError
            return $0
        }
    }
    
    func inject(into service: WordServie) {
        let _:WordServie = define(init: service) {
            $0._unitOfWork = self.serviceAssembly.unitOfWork
            $0._notificationError = self.serviceAssembly.notificationError
            return $0
        }
    }
}
