//
//  TagRepositories.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/7/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

protocol TagRepositoriesType {
    func get(searchStr: String?, skip: Int, take: Int) -> Observable<[TagApiModel]>
    
    func getCount(type: ElementType) -> Observable<Int>
    func get(type: ElementType) -> Observable<[TagApiModel]>
    
    func addCachedTags() -> Observable<Bool>
    
    func updateTag(skip: Int) -> Observable<Int>
    
    func removeAll() -> Completable
}

class TagRepositories: TagRepositoriesType {
    
    var _apiDataProvider: ApiDataProviderType!
    var _storageProvider: RealmStorageProviderType!
    
    init () {
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    func get(searchStr: String?, skip: Int, take: Int) -> Observable<[TagApiModel]> {
        return _storageProvider.tag.getMany(filter: "name == '\(searchStr ?? "")'", skip: skip, take: take).map({ $0.map({ $0.deserialize() }) })
    }
    
    func getCount(type: ElementType) -> Observable<Int> {
        return _storageProvider.tag.count(filter: QueryFactories.getDefaultQuery(type: type))
    }
    func get(type: ElementType) -> Observable<[TagApiModel]> {
        return _storageProvider.tag.getMany(filter: QueryFactories.getDefaultQuery(type: type)).map({ $0.map({ $0.deserialize() }) })
    }
    
    func addCachedTags() -> Observable<Bool> {
        return _storageProvider.tag.getMany(filter: QueryFactories.getDefaultQuery(type: .newNotSynced))
            .flatMap({ Observable.from($0) })
            .flatMap({ (tag) -> Observable<Bool> in
                let id = tag.id
                return self._apiDataProvider.addTag(name: tag.name)
                    .inBackground()
                    .flatMap({ self._storageProvider.tag.saveOne(model: $0).toObservable() })
                    .flatMap({ _ in self._storageProvider.tag.delete(filter: "id == '\(id)'").toObservable() })
            })
    }
    
    func updateTag(skip: Int) -> Observable<Int> {
        return _apiDataProvider.getTags(skip: skip)
            .flatMap({ tag in
                self._storageProvider.tag.saveMany(models: tag)
                    .toObservable()
                    .map({ _ in tag })
            }).map({ $0.count })
    }
    
    func removeAll() -> Completable {
        return _storageProvider.answer.deleteAll()
    }
}
