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
    func getTags() -> Observable<[TagApiModel]>
    func getWord() -> Observable<[WordApiModel]>
}

class ApiService: IApiService {
    
    var _httpService: IHttpService!
    
    init() {
         ServiceInjectorAssembly.instance().inject(into: self)
        _httpService.url = Constants.apiUrl
        _httpService.token = KeychainSwift().get(Constants.tokenKey) ?? ""
    }
    
    func getTags() -> Observable<[TagApiModel]> {
        return _httpService.get(controller: .tag("get")).getResult(ofType: [TagApiModel].self)//.saveInDB()
    }
    
    func getWord() -> Observable<[WordApiModel]> {
        return _httpService.get(controller: .word("get")).getResult(ofType: [WordApiModel].self)
    }
}

extension ObservableType {
//    func saveInDB<T>() -> Observable<T>
//        where T: RealmCodable
//    {
//
//    }
//
//    func saveInDB<T>() -> Observable<[T]>
//        where T: RealmCodable
//    {
//
//    }
}
