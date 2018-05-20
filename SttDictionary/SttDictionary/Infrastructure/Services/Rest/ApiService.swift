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
