//
//  SyncDervice.swift
//  SttDictionary
//
//  Created by Admin on 5/20/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift
import SINQ

enum SyncStep {
    case UploadWord, UpdateWord
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
        return _notificationError.useError(observable: _unitOfWork.syncData.getOrCreateSingletoon()
                                                                           .map( { $0.deserialize() } ))
    }
    
    func sync() -> Observable<(Bool, SyncStep)> {
        return Observable.concat([sendWord(),
                                  updateWord(),
                                  _apiServicce.updateWords().map({ _ in (true, SyncStep.DonwloadWord)}),
                                  _apiServicce.updateTags().map({ _ in (true, SyncStep.DonwloadTag)} )])
    }
    
    private func sendWord() -> Observable<(Bool, SyncStep)> {
        return self._unitOfWork.word.getMany(filter: "isSynced == false and id beginswith '\(Constants.temporyPrefix)'")
            .flatMap({ Observable.from($0) })
            .do(onNext: { print($0.originalWorld) })
            .flatMap({ self._apiServicce.sendWord(model: AddWordApiModel(word: $0.originalWorld, translations: $0.translations.map( { $0.value } ))) })
            .flatMap({ (word) -> Observable<(Bool, SyncStep)> in
                return self._unitOfWork.word.delete(filter: "originalWorld = '\(word.originalWorld)'")
                    .toObservable()
                    .flatMap({ _ in self._unitOfWork.word.saveOne(model: word).toObservable() })
                    .map( { _ in (true, SyncStep.UploadWord) } )
            })
    }
    
    private func updateWord() -> Observable<(Bool, SyncStep)> {
        return self._unitOfWork.word.getMany(filter: "isSynced == false and not id beginswith '\(Constants.temporyPrefix)'")
            .flatMap({ Observable.from($0) })
            .do(onNext: { print("id\($0.id)") })
            .flatMap({ self._apiServicce.updateWord(model: UpdateWordApiModel(word: $0.originalWorld, translations: $0.translations.map( { $0.value } ), id: $0.id, statistics: ($0.statistics?.deserialize())!)) })
            .map({ ($0, SyncStep.UpdateWord) })
    }
}
