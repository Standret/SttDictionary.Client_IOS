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
    func updateTags() -> Observable<ResultModel<[TagApiModel]>>
    func updateWords() -> Observable<ResultModel<[WordApiModel]>>
    
    func sendWord(model: AddWordApiModel) -> Observable<WordApiModel>
}

class ApiService: IApiService {
    
    var _httpService: IHttpService!
    var _unitOfWork: IUnitOfWork!
    
    init() {
         ServiceInjectorAssembly.instance().inject(into: self)
        _httpService.url = Constants.apiUrl
        _httpService.token = KeychainSwift().get(Constants.tokenKey) ?? ""
    }
    
    func updateTags() -> Observable<ResultModel<[TagApiModel]>> {
        let apiData = _httpService.get(controller: .tag("get"))
            .getResult(ofType: [TagApiModel].self)
            .saveInDB(saveCallback: _unitOfWork.tag.saveMany(models:))
            .map({ ResultModel(result: $0, isLocal: false )})
        
        return apiData
    }
    
    func updateWords() -> Observable<ResultModel<[WordApiModel]>> {
        let apiData = _httpService.get(controller: .word("get"))
            .getResult(ofType: [WordApiModel].self)
            .saveInDB(saveCallback: _unitOfWork.word.saveMany(models:))
            .map({ ResultModel(result: $0, isLocal: false) })
        
        return apiData
    }
    
    func sendWord(model: AddWordApiModel) -> Observable<WordApiModel> {
        return _httpService.post(controller: .word("add"), dataAny: model.getDictionary())
            .getResult(ofType: WordApiModel.self)
    }
    
}
