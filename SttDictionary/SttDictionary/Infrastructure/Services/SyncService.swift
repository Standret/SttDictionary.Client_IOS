//
//  SyncDervice.swift
//  SttDictionary
//
//  Created by Admin on 5/20/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

enum SyncStep {
    case DonwloadWord, DonwloadTag
}

protocol ISyncService {
    func getSyncData() -> Observable<SyncDataViewModel>
    func sync() -> Observable<(Bool, SyncStep)>
    
    var observe: Observable<SyncDataViewModel> { get }
}

class SyncService: ISyncService {
    
    var _unitOfWork: IUnitOfWork!
    var _apiServicce: IApiService!
    var _notificationError: INotificationError!
    
    var observe: Observable<SyncDataViewModel> {
        return _notificationError.useError(observable: (_unitOfWork.syncData.observe(on: [RealmStatus.Updated])).map({ (transform) -> SyncDataViewModel in
            return transform.0
        }))
    }
    
    init () {
        ServiceInjectorAssembly.instance().inject(into: self)
    }

    
    func getSyncData() -> Observable<SyncDataViewModel> {
        return _notificationError.useError(observable: _unitOfWork.syncData.getOrCreateSingletoon())
    }
    
    func sync() -> Observable<(Bool, SyncStep)> {
        return _notificationError.useError(observable: Observable<(Bool, SyncStep)>.create { (observer) -> Disposable in
            _ = self._unitOfWork.word.getMany(filter: "isSynced == false")
                .subscribe(onNext: { (words) in
                print(words.count)
                for item in words {
                    _ = self._apiServicce.sendWord(model: AddWordApiModel(word: item.originalWorld, translations: item.translations))
                            .subscribe(onNext: { (result) in
                                 _ = self._unitOfWork.word.update(update: { (realmWord) in
                                    realmWord.originalWorld = result.id!
                                }, filter: "originalWorld = '\(item.originalWorld)'")
                                .subscribe(onNext: { print("wordl saved \($0)") })
                        })
                }
                })
            
            return self._apiServicce.getWord().subscribe(onNext: { (words) in
                if words.isSuccess && !words.isLocal {
                    observer.onNext((true, SyncStep.DonwloadWord))
                    
                    _ = self._apiServicce.getTags().subscribe(onNext: { (tags) in
                        if tags.isSuccess && !tags.isLocal {
                            observer.onNext((true, SyncStep.DonwloadTag))
                            
                            // update
                            _ = self._unitOfWork.syncData.update(update: { (obj) in
                                obj.dateOfLastSync = Date()
                            }, filter: nil).subscribe(onNext: { (result) in
                                print("\(result): updated")
                            }, onError: { (error) in
                                print(error)
                            })
                            
                            observer.onCompleted()
                        }
                    }, onError: { (error) in
                        observer.onNext((false, SyncStep.DonwloadTag))
                        observer.onError(error)
                    })
                }
                
            }, onError: { (error) in
                observer.onNext((false, SyncStep.DonwloadWord))
                observer.onError(error)
            })
        })
    }
}
