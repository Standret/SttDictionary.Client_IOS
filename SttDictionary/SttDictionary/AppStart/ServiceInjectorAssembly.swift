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
    
    func inject(into service: ViewPresenter) {
        let _:ViewPresenter = define(init: service) {
            $0._apiService = self.serviceAssembly.apiService
            return $0
        }
    }
    
    // Inject Service into service
    
    func inject(into service: ApiService) {
        let _:ApiService = define(init: service) {
            $0._httpService = self.serviceAssembly.httpService
            return $0
        }
    }
}
