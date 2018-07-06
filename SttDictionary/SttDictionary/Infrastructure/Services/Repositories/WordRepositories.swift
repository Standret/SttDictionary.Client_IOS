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
    func updateWords(skip: Int) -> Observable<Bool>
    func addWord(model: AddWordApiModel) -> Observable<(Bool, SyncStep)>
}

class WordRepositories: WordRepositoriesType {
    
    var _apiDataProvider: ApiDataProviderType!
    var _storageProvider: RealmStorageProviderType!
    
    init () {
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    func updateWords(skip: Int) -> Observable<Bool> {
        return _apiDataProvider.getWords(skip: skip)
            .flatMap({ words in
                self._storageProvider.word.saveMany(models: words)
                    .toObservable()
                    .map({ _ in words })
            }).map({ $0.count > 0 })
    }
    
    func addWord(model: AddWordApiModel) -> Observable<(Bool, SyncStep)> {
        return Observable.concat([
            _storageProvider.word.saveOne(model: try! model.convertToApiModel()).toObservable().map({ ($0, SyncStep.local) }),
            addCachedWords().map({ ($0, SyncStep.server) })
        ])
    }
    
    func addCachedWords() -> Observable<Bool> {
        return _storageProvider.word.getMany(filter: "isSynced == false and id beginswith '\(Constants.temporyPrefix)'")
            .flatMap({ Observable.from($0) })
            .flatMap({ (word) -> Observable<Bool> in
                return self._apiDataProvider.addWord(model: word.convertToApiModel())
                    .flatMap({ self._storageProvider.word.saveOne(model: $0).toObservable() })
                    .flatMap({ _ in self._storageProvider.word.delete(filter: "id == '\(word.id)'").toObservable() })
            })
    }
}
