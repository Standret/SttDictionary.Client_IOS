
//
//  SttRepository.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//


import Foundation
import RealmSwift
import RxRealm
import RxSwift


protocol SttRepositoryType {
    associatedtype TEntity: RealmCodable
    associatedtype TRealm: RealmDecodable
    
    var isSingletoon: Bool { get }
    
    init(singleton: Bool)
    
    func saveOne(model: TEntity) -> Completable
    func saveMany(models: [TEntity]) -> Completable
    
    func getOne(filter: String?) -> Observable<TRealm>
    func getMany(filter: String?, sortBy: String?, isAsc: Bool, skip: Int, take: Int) -> Observable<[TRealm]>
    
    func update(update: @escaping (_ dbObject: TRealm) -> Void, filter: String?) -> Completable
    
    func delete(model: TEntity) -> Completable
    func delete(filter: String?) -> Completable
    
    func exists(filter: String?) -> Observable<Bool>
    func count(filter: String?) -> Observable<Int>
    
    func observe(on: [RealmStatus]) -> Observable<(TRealm, RealmStatus)>
}

class SttRepository<T, R>: SttRepositoryType
    where T: RealmCodable,
    R: RealmDecodable,
    R: SttRealmObject {
    
    typealias TEntity = T
    typealias TRealm = R
    
    private func getObjects<TArg>(filter: String?, sortBy: String? = nil, isAsc: Bool = false, observer: AnyObserver<TArg>, tryGetAll: Bool) throws -> Results<R> {
        let realm = try Realm()
        var objects: Results<R>!
        if let query = filter {
            if (self.singleton) {
                observer.onError(SttBaseError.realmError(SttRealmError.objectIsSignleton("type: \(type(of: R.self))")))
            }
            else {
                objects = realm.objects(R.self).filter(query).sorted(byKeyPath: sortBy ?? "dateCreated", ascending: isAsc)
            }
        }
        else {
            if (!self.singleton && !tryGetAll) {
                observer.onError(SttBaseError.realmError(SttRealmError.queryIsNull("type: \(type(of: R.self))")))
            }
            else {
                objects = realm.objects(R.self).sorted(byKeyPath: sortBy ?? "dateCreated", ascending: isAsc)
            }
        }
        return objects
    }
    private func getObjects(filter: String?, observer: PrimitiveSequenceType.CompletableObserver, tryGetAll: Bool) throws -> Results<R> {
        let realm = try Realm()
        var objects: Results<R>!
        if let query = filter {
            if (self.singleton) {
                observer(CompletableEvent.error(SttBaseError.realmError(SttRealmError.objectIsSignleton("type: \(type(of: R.self))"))))
            }
            else {
                objects = realm.objects(R.self).filter(query)
            }
        }
        else {
            if (!self.singleton && !tryGetAll) {
                observer(CompletableEvent.error(SttBaseError.realmError(SttRealmError.queryIsNull("type: \(type(of: R.self))"))))
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
                print("saveOne \(Thread.current)")
                let realm = try Realm()
//                if (realm.objects(R.self).count > 0) {
//                    observer(CompletableEvent.error(SttBaseError.realmError(SttRealmError.objectIsSignleton("method: saveOne type: \(type(of: R.self))"))))
//                }
                print(Thread.current)
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
                observer(CompletableEvent.error(SttBaseError.realmError(SttRealmError.objectIsSignleton("method: saveMany type: \(type(of: R.self))"))))
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
    
    func getOne(filter: String?) -> Observable<R> {
        return Observable<R>.create { (observer) -> Disposable in
            do {
                print("getOne \(Thread.current)")
                let objects = try self.getObjects(filter: filter, observer: observer, tryGetAll: false)
                if (objects.count > 1) {
                    observer.onError(SttBaseError.realmError(SttRealmError.doesNotExactlyQuery("method: getOne type: \(type(of: R.self)) with filter \(filter ?? "nil")")))
                }
                else if objects.count != 0 {
                    observer.onNext(objects[0])
                }
                observer.onCompleted()
            }
            catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func getMany(filter: String?, sortBy: String?, isAsc: Bool, skip: Int, take: Int) -> Observable<[R]> {
        return Observable<[R]>.create { (observer) -> Disposable in
            do {
                let objects = try self.getObjects(filter: filter, sortBy: sortBy, isAsc: isAsc, observer: observer, tryGetAll: true)
                observer.onNext(Array(objects.prefix(take)))
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
                if (objects.count > 1) {
                    observer(CompletableEvent.error(SttBaseError.realmError(SttRealmError.doesNotExactlyQuery("method: update type: \(type(of: R.self)) with filter \(filter ?? "nil"))"))))
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
                        observer(CompletableEvent.error(SttBaseError.realmError(SttRealmError.objectIsSignleton("type: \(type(of: R.self))"))))
                    }
                    else {
                        objects = realm.objects(R.self).filter(query)
                    }
                }
                else {
                    objects = realm.objects(R.self)
                }
                
                if objects.count == 0 {
                    observer(CompletableEvent.error(SttBaseError.realmError(SttRealmError.notFoundObjects("method: delete type: \(type(of: R.self)) with filter \(filter ?? "nil"))"))))
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
                observer.onError(SttBaseError.realmError(SttRealmError.objectIsSignleton("method: count type: \(type(of: R.self))")))
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
    
    func observe(on: [RealmStatus]) -> Observable<(R, RealmStatus)> {
        return Observable<(R, RealmStatus)>.create { (observer) -> Disposable in
            do {
                let objects = try self.getObjects(filter: nil, observer: observer, tryGetAll: true)
                return Observable.arrayWithChangeset(from: objects).subscribe(onNext: { (array, changes) in
                    if let changes = changes {
                        if on.contains(RealmStatus.Inserted) {
                            for itemInserted in changes.inserted {
                                observer.onNext((array[itemInserted], RealmStatus.Inserted))
                            }
                        }
                        if on.contains(RealmStatus.Deleted) {
                            for itemDeleted in changes.deleted {
                                observer.onNext((array[itemDeleted], RealmStatus.Deleted))
                            }
                        }
                        if on.contains(RealmStatus.Updated) {
                            for itemUpdated in changes.updated {
                                observer.onNext((array[itemUpdated], RealmStatus.Updated))
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
