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
    func getTags() -> Observable<ResultModel<[TagApiModel]>>
    func getWord() -> Observable<ResultModel<[WordApiModel]>>
}

class FakeApiService: IApiService {
    
    var _httpService: IHttpService!
    var _unitOfWork: IUnitOfWork!

    init() {
        ServiceInjectorAssembly.instance().inject(into: self)
        _httpService.url = Constants.apiUrl
        _httpService.token = KeychainSwift().get(Constants.tokenKey) ?? ""
    }
    
    func getTags() -> Observable<ResultModel<[TagApiModel]>> {
        let json = """
[{"name":"fruit","wordsId":["5af883bb9533913a308f66af", "5af883cb9533913a308f66b0"],"statisticsWord":null,"id":"5af883a29533913a308f66ae","dateCreated":"2018-05-13T09:27:45Z","isDeleted":false},{"name":"unit1","wordsId":["5af883cb9533913a308f66b0"],"statisticsWord":null,"id":"5af8840f9533913a308f66b1","dateCreated":"2018-05-13T09:29:34Z","isDeleted":false}]
"""
        return json.getResult(ofType: [TagApiModel].self).saveInDB(saveCallback: _unitOfWork.tag.saveMany(models:)).map({ ResultModel(result: $0, isLocal: false) })
    }
    
    func getWord() -> Observable<ResultModel<[WordApiModel]>> {
        let json = """
[{"id":"5af88245888dd44378565c4a","dateCreated":"2018-05-13T09:21:57Z","originalWorld":"book","translations":["книга","бронювати"],"additionalTranslations":["том"],"tags":[],"imageUrls":null,"statistics":null},{"id":"5af88266888dd44378565c4b","dateCreated":"2018-05-13T09:22:30Z","originalWorld":"key","translations":["клавіша","ключ"],"additionalTranslations":null,"tags":[],"imageUrls":null,"statistics":null},{"id":"5af883bb9533913a308f66af","dateCreated":"2018-05-13T09:28:11Z","originalWorld":"cherry","translations":["вишня"],"additionalTranslations":null,"tags":[{"id":"5af883a29533913a308f66ae","name":"fruit"}],"imageUrls":null,"statistics":null},{"id":"5af883cb9533913a308f66b0","dateCreated":"2018-05-13T09:28:27Z","originalWorld":"apple","translations":["яблуко"],"additionalTranslations":null,"tags":[{"id":"5af883a29533913a308f66ae","name":"fruit"},{"id":"5af8840f9533913a308f66b1","name":"unit1"}],"imageUrls":null,"statistics":null}]
"""
        let dbData = _unitOfWork.word.getMany(filter: nil).map( { ResultModel(result: $0, isLocal: true) } )
        print (dbData)
        let apiData = json
            .getResult(ofType: [WordApiModel].self)
            .saveInDB(saveCallback: _unitOfWork.word.saveMany(models:))
            .map({ ResultModel(result: $0, isLocal: false) })
        
        return Observable.of(dbData, apiData).merge()
    }
}

class ApiService: IApiService {
    
    var _httpService: IHttpService!
    var _unitOfWork: IUnitOfWork!
    
    init() {
         ServiceInjectorAssembly.instance().inject(into: self)
        _httpService.url = Constants.apiUrl
        _httpService.token = KeychainSwift().get(Constants.tokenKey) ?? ""
    }
    
    func getTags() -> Observable<ResultModel<[TagApiModel]>> {
        let apiData = _httpService.get(controller: .tag("get"))
            .getResult(ofType: [TagApiModel].self)
            .saveInDB(saveCallback: _unitOfWork.tag.saveMany(models:))
            .map({ ResultModel(result: $0, isLocal: false )})
        
        let dbData = _unitOfWork.tag.getMany(filter: nil)
            .map( { ResultModel(result: $0, isLocal: true) } )
        
        return Observable.of(dbData, apiData).merge()
    }
    
    func getWord() -> Observable<ResultModel<[WordApiModel]>> {
        let apiData = _httpService.get(controller: .word("get"))
            .getResult(ofType: [WordApiModel].self)
            .saveInDB(saveCallback: _unitOfWork.word.saveMany(models:))
            .map({ ResultModel(result: $0, isLocal: false) })
        
        let dbData = _unitOfWork.word.getMany(filter: nil)
            .map( { ResultModel(result: $0, isLocal: true) } )
        
        return Observable.of(dbData, apiData).merge()
    }
    
}

//extension Observable where Element: RealmCodable {
//    func saveInDB(saveCallback: @escaping (_ obj: Element) -> Observable<Bool>) throws -> Observable<Element>
//    {
//        return self.do(onNext: { element in
//           _ = saveCallback(element)
//        }, onError: nil, onCompleted: nil, onSubscribe: nil, onSubscribed: nil, onDispose: nil)
//    }
//}

extension Observable {
    func saveInDB(saveCallback: @escaping (_ saveCallback: Element) -> Observable<Bool>) -> Observable<Element>
    {
        return self.map({ (element) -> Element in
            _ = saveCallback(element).subscribe(onNext: { (element) in
                Log.trace(message: "\(type(of: Element.self)) has been saved succefully in realm", key: Constants.repositoryExtensionsLog)
            }, onError: { (error) in
                Log.error(message: "\(type(of: Element.self)) could not save in db", key: Constants.repositoryExtensionsLog)
            })
            return element
        })
    }
}
