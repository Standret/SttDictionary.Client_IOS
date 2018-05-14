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

class FakeApiService: IApiService {
    
    var _httpService: IHttpService!
    
    init() {
        ServiceInjectorAssembly.instance().inject(into: self)
        _httpService.url = Constants.apiUrl
        _httpService.token = KeychainSwift().get(Constants.tokenKey) ?? ""
    }
    
    func getTags() -> Observable<[TagApiModel]> {
        let json = """
[{"name":"fruit","wordsId":["5af883bb9533913a308f66af"],"statisticsWord":null,"id":"5af883a29533913a308f66ae","dateCreated":"2018-05-13T09:27:45Z","isDeleted":false},{"name":"unit1","wordsId":[],"statisticsWord":null,"id":"5af8840f9533913a308f66b1","dateCreated":"2018-05-13T09:29:34Z","isDeleted":false}]
"""
        return json.getResult(ofType: [TagApiModel].self)//.saveInDB()
    }
    
    func getWord() -> Observable<[WordApiModel]> {
        let json = """
[{"id":"5af88245888dd44378565c4a","dateCreated":"2018-05-13T09:21:57Z","originalWorld":"book","translations":["книга","бронювати"],"additionalTranslations":["том"],"tags":[],"imageUrls":null,"statistics":null},{"id":"5af88266888dd44378565c4b","dateCreated":"2018-05-13T09:22:30Z","originalWorld":"key","translations":["клавіша","ключ"],"additionalTranslations":null,"tags":[],"imageUrls":null,"statistics":null},{"id":"5af883bb9533913a308f66af","dateCreated":"2018-05-13T09:28:11Z","originalWorld":"cherry","translations":["вишня"],"additionalTranslations":null,"tags":[{"id":"5af883a29533913a308f66ae","name":"fruit"}],"imageUrls":null,"statistics":null},{"id":"5af883cb9533913a308f66b0","dateCreated":"2018-05-13T09:28:27Z","originalWorld":"apple","translations":["яблуко"],"additionalTranslations":null,"tags":[{"id":"5af883a29533913a308f66ae","name":"fruit"},{"id":"5af8840f9533913a308f66b1","name":"unit1"}],"imageUrls":null,"statistics":null}]
"""
        return json.getResult(ofType: [WordApiModel].self)
    }
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
