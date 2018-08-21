//
//  WordRepositories.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/6/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

enum SyncStep {
    case local
    case server
}

protocol WordRepositoriesType {
    func updateWords(skip: Int) -> Observable<Int>
    func addWord(model: AddWordApiModel) -> Observable<(Bool, SyncStep)>
    func addCachedWords() -> Observable<Bool>
    
    func getAll(searchStr: String?) -> Observable<[WordApiModel]>
    func getWords(type: ElementType) -> Observable<[WordApiModel]>
    func getCount(type: ElementType) -> Observable<Int>
    
    func getWords(statistics: [WordStatisticsApiModel]) -> Observable<[WordApiModel]>
    func getWords(answers: [AnswerApiModel]) -> Observable<[WordApiModel]>

    func exists(originalWord: String) -> Observable<Bool>
    
    func removeAll() -> Completable
}

class WordRepositories: WordRepositoriesType {
    
    var _apiDataProvider: ApiDataProviderType!
    var _storageProvider: RealmStorageProviderType!
    
    init () {
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    func updateWords(skip: Int) -> Observable<Int> {
        return _apiDataProvider.getWords(skip: skip)
            .flatMap({ words in
                self._storageProvider.word.saveMany(models: words)
                    .toObservable()
                    .map({ _ in words })
            }).map({ $0.count })
    }
    
    func addWord(model: AddWordApiModel) -> Observable<(Bool, SyncStep)> {
        return Observable.concat([
            _storageProvider.word.saveOne(model: try! model.convertToApiModel()).toObservable().map({ ($0, SyncStep.local) }),
            addCachedWords().map({ ($0, SyncStep.server) })
        ])
    }
    
    func addCachedWords() -> Observable<Bool> {
        return _storageProvider.word.getMany(filter: QueryFactories.getDefaultQuery(type: .newNotSynced))
            .flatMap({ Observable.from($0) })
            .flatMap({ (word) -> Observable<Bool> in
                let id = word.id
                return self._apiDataProvider.addWord(model: word.convertToApiModel())
                    .inBackground()
                    .flatMap({ self._storageProvider.word.saveOne(model: $0).toObservable() })
                    .flatMap({ _ in self._storageProvider.word.delete(filter: "id == '\(id)'").toObservable() })
            })
    }
    
    func getAll(searchStr: String?) -> Observable<[WordApiModel]> {
        return _storageProvider.word.getMany(filter: QueryFactories.getWordQuery(text: searchStr)).map({ $0.map({ $0.deserialize() }) })
    }
    func getWords(type: ElementType) -> Observable<[WordApiModel]> {
        return _storageProvider.word.getMany(filter: QueryFactories.getDefaultQuery(type: type)).map({ $0.map({ $0.deserialize() }) })
    }
    func getCount(type: ElementType) -> Observable<Int> {
        return _storageProvider.word.count(filter: QueryFactories.getDefaultQuery(type: type))
    }
    
    func getWords(statistics: [WordStatisticsApiModel]) -> Observable<[WordApiModel]> {
        let predicateFormat = NSPredicate(format: "id IN %@", argumentArray: [Array(Set(statistics.map({ $0.wordId })))]).predicateFormat
        return _storageProvider.word.getMany(filter: predicateFormat)
            .map({ $0.map({ $0.deserialize() }) })
    }
    func getWords(answers: [AnswerApiModel]) -> Observable<[WordApiModel]> {
        let predicateFormat = NSPredicate(format: "id IN %@", argumentArray: [Array(Set(answers.map({ $0.wordId })))]).predicateFormat
        return _storageProvider.word.getMany(filter: predicateFormat)
            .map({ $0.map({ $0.deserialize() }) })
    }
    
    func exists(originalWord: String) -> Observable<Bool> {
        return _storageProvider.word.exists(filter: "originalWorld = '\(originalWord)'")
    }
    
    func removeAll() -> Completable {
        return _storageProvider.answer.deleteAll()
    }
}
