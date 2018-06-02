//
//  Repository.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//


import Foundation
import RealmSwift
import RxRealm
import RxSwift

enum RealmStatus {
    case Updated, Deleted, Inserted
}

protocol RealmCodable {
    associatedtype TTarget: Object, RealmDecodable
    
    func serialize() -> TTarget
}

protocol RealmDecodable {
    associatedtype TTarget
    
    init()
    func deserialize() -> TTarget
}

protocol IRepository {
    associatedtype TEntity: RealmCodable
    associatedtype TRealm: RealmDecodable
    
    var isSingletoon: Bool { get }
    
    init(singleton: Bool)
    
    func saveOne(model: TEntity) -> Completable
    func saveMany(models: [TEntity]) -> Completable
    
    func getOne(filter: String?) -> Observable<TEntity>
    func getMany(filter: String?) -> Observable<[TEntity]>
    
    func getManyOriginal(filter: String?) -> Observable<[TRealm]>
    
    func update(update: @escaping (_ dbObject: TRealm) -> Void, filter: String?) -> Completable
    
    func delete(model: TEntity) -> Completable
    func delete(filter: String?) -> Completable
    
    func exists(filter: String?) -> Observable<Bool>
    func count(filter: String?) -> Observable<Int>
    //func save(model: TEntity)
    func observe(on: [RealmStatus]) -> Observable<(TEntity, RealmStatus)>
}

class Repository<T, R>: IRepository
    where T: RealmCodable,
    R: RealmDecodable,
    R: BaseRealm {
    
    typealias TEntity = T
    typealias TRealm = R
    
    private func getObjects<TArg>(filter: String?, observer: AnyObserver<TArg>, tryGetAll: Bool) throws -> Results<R> {
        let realm = try Realm()
        var objects: Results<R>!
        if let query = filter {
            if (self.singleton) {
                observer.onError(BaseError.realmError(RealmError.objectIsSignleton("type: \(type(of: R.self))")))
            }
            else {
                objects = realm.objects(R.self).filter(query).sorted(byKeyPath: "dateCreated", ascending: false)
            }
        }
        else {
            if (!self.singleton && !tryGetAll) {
                observer.onError(BaseError.realmError(RealmError.queryIsNull("type: \(type(of: R.self))")))
            }
            else {
                objects = realm.objects(R.self).sorted(byKeyPath: "dateCreated", ascending: false)
            }
        }
        return objects
    }
    private func getObjects(filter: String?, observer: PrimitiveSequenceType.CompletableObserver, tryGetAll: Bool) throws -> Results<R> {
        let realm = try Realm()
        var objects: Results<R>!
        if let query = filter {
            if (self.singleton) {
                observer(CompletableEvent.error(BaseError.realmError(RealmError.objectIsSignleton("type: \(type(of: R.self))"))))
            }
            else {
                objects = realm.objects(R.self).filter(query)
            }
        }
        else {
            if (!self.singleton && !tryGetAll) {
                observer(CompletableEvent.error(BaseError.realmError(RealmError.queryIsNull("type: \(type(of: R.self))"))))
            }
            else {
                objects = realm.objects(R.self)
            }
        }
        return objects
    }
    
    private var singleton: Bool!
    var isSingletoon: Bool { return singleton }
    
    required init(singleton: Bool) {
        self.singleton = singleton
    }
    
    func saveOne(model: T) -> Completable {
        return Completable.create { (observer) -> Disposable in
            do {
                let realm = try Realm()
                if (self.singleton && realm.objects(R.self).count > 0) {
                    observer(CompletableEvent.error(BaseError.realmError(RealmError.objectIsSignleton("method: saveOne type: \(type(of: R.self))"))))
                }
                realm.beginWrite()
                realm.add(model.serialize(), update: true)
                try realm.commitWrite()
                observer(CompletableEvent.completed)
            }
            catch {
                observer(CompletableEvent.error(error))
            }
            
            return Disposables.create()
            }
    }
    
    func saveMany(models: [T]) -> Completable {
        return Completable.create { (observer) -> Disposable in
            if (self.singleton) {
                observer(CompletableEvent.error(BaseError.realmError(RealmError.objectIsSignleton("method: saveMany type: \(type(of: R.self))"))))
            }
            do {
                let realm = try Realm()
                realm.beginWrite()
                for item in models {
                    realm.add(item.serialize(), update: true)
                }
                try realm.commitWrite()
                observer(CompletableEvent.completed)
            }
            catch {
                observer(CompletableEvent.error(error))
            }
            
            return Disposables.create()
            }
    }
    
    func getOne(filter: String?) -> Observable<T> {
        return Observable<T>.create { (observer) -> Disposable in
            do {
                let objects = try self.getObjects(filter: filter, observer: observer, tryGetAll: false)
                if (objects.count != 1) {
                    observer.onError(BaseError.realmError(RealmError.doesNotExactlyQuery("method: getOne type: \(type(of: R.self)) with filter \(filter ?? "nil")")))
                }
                else {
                    observer.onNext(objects[0].deserialize() as! T)
                }
                observer.onCompleted()
            }
            catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func getMany(filter: String?) -> Observable<[T]> {
        return Observable<[T]>.create { (observer) -> Disposable in
            do {
                let objects = try self.getObjects(filter: filter, observer: observer, tryGetAll: true)
                
                var results = [T]()
                for item in objects {
                    results.append(item.deserialize() as! T)
                }
                observer.onNext(results)
                observer.onCompleted()
            }
            catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func getManyOriginal(filter: String?) -> Observable<[R]> {
        return Observable<[R]>.create { (observer) -> Disposable in
            do {
                let objects = try self.getObjects(filter: filter, observer: observer, tryGetAll: true)

                observer.onNext(objects.toArray())
                observer.onCompleted()
            }
            catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func update(update: @escaping (R) -> Void, filter: String?) -> Completable {
        return Completable.create { (observer) -> Disposable in
            do {
                let realm = try Realm()
                let objects = try self.getObjects(filter: filter, observer: observer, tryGetAll: false)
                if (objects.count != 1) {
                    observer(CompletableEvent.error(BaseError.realmError(RealmError.doesNotExactlyQuery("method: update type: \(type(of: R.self)) with filter \(filter ?? "nil"))"))))
                }
                else {
                    try realm.write {
                        update(objects[0]) // check this method
                    }
                }
               // Comple
                observer(CompletableEvent.completed)
            }
            catch {
                observer(CompletableEvent.error(error))
            }
            
                return Disposables.create()
            }
    }
    
    func delete(model: T) -> Completable {
        return Completable.create { (observer) -> Disposable in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(model.serialize())
                }
                observer(CompletableEvent.completed)
            }
            catch {
                observer(CompletableEvent.error(error))
            }
            
            return Disposables.create()
            }
    }
    
    func delete(filter: String?) -> Completable {
        return Completable.create { (observer) -> Disposable in
            do {
                let realm = try Realm()
                
                var objects: Results<R>!
                if let query = filter {
                    if (self.singleton) {
                        observer(CompletableEvent.error(BaseError.realmError(RealmError.objectIsSignleton("type: \(type(of: R.self))"))))
                    }
                    else {
                        objects = realm.objects(R.self).filter(query)
                    }
                }
                else {
                    objects = realm.objects(R.self)
                }
                
                if objects.count == 0 {
                    observer(CompletableEvent.error(BaseError.realmError(RealmError.notFoundObjects("method: delete type: \(type(of: R.self)) with filter \(filter ?? "nil"))"))))
                }
                else {
                    try realm.write {
                        for item in objects {
                            realm.delete(item)
                        }
                    }
                    observer(CompletableEvent.completed)
                }
            }
            catch {
                observer(CompletableEvent.error(error))
            }
            
                return Disposables.create()
            }
    }
    
    func exists(filter: String?) -> Observable<Bool> {
        return Observable<Bool>.create { (observer) -> Disposable in
            do {
                let objects = try self.getObjects(filter: filter, observer: observer, tryGetAll: true)
                observer.onNext(objects.count > 0)
                observer.onCompleted()
            }
            catch {
                observer.onError(error)
            }
            
            return Disposables.create()
            }
    }
    
    func count(filter: String?) -> Observable<Int> {
        return Observable<Int>.create { (observer) -> Disposable in
            if (self.singleton) {
                observer.onError(BaseError.realmError(RealmError.objectIsSignleton("method: count type: \(type(of: R.self))")))
                return Disposables.create()
            }
            do {
                let realm = try Realm()
                if let query = filter {
                    observer.onNext(realm.objects(R.self).filter(query).count)
                }
                else {
                    observer.onNext(realm.objects(R.self).count)
                }
                observer.onCompleted()
            }
            catch {
                observer.onError(error)
            }
            
            return Disposables.create()
            }
    }
    
    func observe(on: [RealmStatus]) -> Observable<(T, RealmStatus)> {
        return Observable<(T, RealmStatus)>.create { (observer) -> Disposable in
            do {
                let objects = try self.getObjects(filter: nil, observer: observer, tryGetAll: true)
                return Observable.arrayWithChangeset(from: objects).subscribe(onNext: { (array, changes) in
                    if let changes = changes {
                        if on.contains(RealmStatus.Inserted) {
                            for itemInserted in changes.inserted {
                                observer.onNext((array[itemInserted].deserialize() as! T, RealmStatus.Inserted))
                            }
                        }
                        if on.contains(RealmStatus.Deleted) {
                            for itemDeleted in changes.deleted {
                                observer.onNext((array[itemDeleted].deserialize() as! T, RealmStatus.Deleted))
                            }
                        }
                        if on.contains(RealmStatus.Updated) {
                            for itemUpdated in changes.updated {
                                observer.onNext((array[itemUpdated].deserialize() as! T, RealmStatus.Updated))
                            }
                        }
                    }
                }, onError: observer.onError(_:))
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
}

extension IRepository
where TEntity: Defaultable {
    func getOrCreateSingletoon() -> Observable<TEntity> {
        return self.exists(filter: nil)
            .flatMap({ (result) -> Observable<TEntity> in
                if (result) {
                    return self.getOne(filter: nil)
                }
                return self.saveOne(model: FactoryDefaultsObject.create(ofType: TEntity.self))
                    .asObservable()
                    .flatMap({ _ in self.getOne(filter: nil) })
            })
        }
}
