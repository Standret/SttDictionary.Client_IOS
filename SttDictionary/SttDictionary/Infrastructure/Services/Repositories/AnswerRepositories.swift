//
//  AnswerRepositories.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/7/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift
import SINQ

protocol AnswerRepositoriesType {
    func getCount(type: ElementType) -> Observable<Int>
    func getStatistics(type: ElementType) -> Observable<[AnswerApiModel]>
    
    func getTodayAnswers() -> Observable<[AnswerApiModel]>
    func getAnswers(wordIds: [String]) -> Observable<[AnswerApiModel]>
    
    func addCachedAnswers() -> Observable<Int>
    
    func updateAnswer(skip: Int) -> Observable<Int>
    func updateAnswer(model: AnswerApiModel) -> Observable<Bool>
    
    func removeAll() -> Completable
}

class AnswerRepositories: AnswerRepositoriesType {
    
    var _apiDataProvider: ApiDataProviderType!
    var _storageProvider: RealmStorageProviderType!
    
    init () {
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    func getCount(type: ElementType) -> Observable<Int> {
        return _storageProvider.answer.count(filter: QueryFactories.getDefaultQuery(type: type))
    }
    func getStatistics(type: ElementType) -> Observable<[AnswerApiModel]> {
        return _storageProvider.answer.getMany(filter: QueryFactories.getDefaultQuery(type: type)).map({ $0.map({ $0.deserialize() }) })
    }
    func getTodayAnswers() -> Observable<[AnswerApiModel]> {
        let predicateFormat = NSPredicate(format: "dateCreated = %@", argumentArray: [Date().onlyDay()]).predicateFormat
        return _storageProvider.answer.getMany(filter: predicateFormat).map({ $0.map({ $0.deserialize() }) })
    }
    func getAnswers(wordIds: [String]) -> Observable<[AnswerApiModel]> {
        let predicateFormat = NSPredicate(format: "wordId IN %@", argumentArray: [Array(Set(wordIds))]).predicateFormat
        return _storageProvider.answer.getMany(filter: predicateFormat).map({ $0.map({ $0.deserialize() }) })
    }
    
    func addCachedAnswers() -> Observable<Int> {
        return _storageProvider.answer.getMany(filter: QueryFactories.getDefaultQuery(type: .newNotSynced))
            .flatMap({ (answers) -> Observable<Int> in
                let count = answers.count
                let wordsId = answers.map({ $0.wordId })
                var model = [String: [AnswerDataApiModel]]()
                for item in wordsId {
                    model[item] = sinq(answers).whereTrue({ $0.wordId == item }).map({ $0.convertToApiModel() })
                }
                if model.count > 0 {
                    let predicateFormat = NSPredicate(format: "id IN %@", argumentArray: [Array(Set(answers.map({ $0.id })))]).predicateFormat
                    return self._apiDataProvider.updateAnswers(answers: UpdateAnswerApiModel(answers: model))
                        .flatMap({ _ in self._storageProvider.answer.delete(filter: predicateFormat) })
                        .map({ _ in count })
                }
                return Observable<Int>.empty()
            })
    }

    
    func updateAnswer(skip: Int) -> Observable<Int> {
        return _apiDataProvider.getAnswers(skip: skip)
            .flatMap({ answer in
                self._storageProvider.answer.saveMany(models: answer)
                    .toObservable()
                    .map({ _ in answer })
            }).map({ $0.count })
    }
    func updateAnswer(model: AnswerApiModel) -> Observable<Bool> {
        return _storageProvider.answer.saveOne(model: model).toObservable()
    }
    
    func removeAll() -> Completable {
        return _storageProvider.answer.deleteAll()
    }
}
