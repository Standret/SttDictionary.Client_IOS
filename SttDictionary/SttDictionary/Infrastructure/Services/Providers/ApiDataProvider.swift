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

protocol ApiDataProviderType {
    
    // word
    func addWord(model: AddWordApiModel) -> Observable<WordApiModel>
    func updateWord(model: UpdateWordApiModel) -> Observable<Bool>
    func getWords(skip: Int) -> Observable<[WordApiModel]>
    func deleteWords(id: String) -> Observable<Bool>
    
    // tag
    func addTag(name: String) -> Observable<TagApiModel>
    func getTags(skip: Int) -> Observable<[TagApiModel]>
    func deleteTags(id: String) -> Observable<Bool>
    
    // answer
    func updateAnswers(answers: UpdateAnswerApiModel) -> Observable<Bool>
    func getAnswers(skip: Int) -> Observable<[AnswerApiModel]>
    
    // statistics
    func getWordsStatistics(skip: Int) -> Observable<[WordStatisticsApiModel]>
    func getCount() -> Observable<CountApiModel>
}

class ApiDataProvider: ApiDataProviderType {
    
    var _httpService: SttHttpServiceType!
    
    init() {
         ServiceInjectorAssembly.instance().inject(into: self)
        _httpService.url = Constants.apiUrl
        _httpService.token = KeychainSwift().get(Constants.tokenKey) ?? ""
    }
    
    // word
    func addWord(model: AddWordApiModel) -> Observable<WordApiModel> {
        return _httpService.post(controller: .word("add"), data: model)
            .getResult(ofType: WordApiModel.self)
    }
    func updateWord(model: UpdateWordApiModel) -> Observable<Bool> {
        return _httpService.post(controller: .word("update"), data: model)
            .getResult()
    }
    func getWords(skip: Int) -> Observable<[WordApiModel]> {
        return _httpService.get(controller: .word("get"), data: ["skip": "\(skip)"])
            .getResult(ofType: [WordApiModel].self)
    }
    func deleteWords(id: String) -> Observable<Bool> {
        return Observable<Bool>.empty()
    }
    
    // tag
    func addTag(name: String) -> Observable<TagApiModel> {
        return _httpService.post(controller: .tag("add"), data: name)
            .getResult(ofType: TagApiModel.self)
    }
    func getTags(skip: Int) -> Observable<[TagApiModel]> {
        return _httpService.get(controller: .tag("get"), data: ["skip": "\(skip)"])
            .getResult(ofType: [TagApiModel].self)
    }
    func deleteTags(id: String) -> Observable<Bool> {
        return Observable<Bool>.empty()
    }
    
    // answer
    func updateAnswers(answers: UpdateAnswerApiModel) -> Observable<Bool> {
        return _httpService.post(controller: .answer("update"), data: answers)
            .getResult()
    }
    func getAnswers(skip: Int) -> Observable<[AnswerApiModel]> {
        return _httpService.get(controller: .answer("get"), data: ["skip": "\(skip)"])
            .getResult(ofType: [AnswerApiModel].self)
    }
    
    // statistics
    func getWordsStatistics(skip: Int) -> Observable<[WordStatisticsApiModel]> {
        return _httpService.get(controller: .statistics("get"), data: ["skip": "\(skip)"])
            .getResult(ofType: [WordStatisticsApiModel].self)
    }
    func getCount() -> Observable<CountApiModel> {
        return _httpService.get(controller: .statistics("counts"))
            .getResult(ofType: CountApiModel.self)
    }
}
