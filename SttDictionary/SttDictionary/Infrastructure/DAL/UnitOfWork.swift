//
//  UnitOfWork.swift
//  SttDictionary
//
//  Created by Standret on 14.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol UnitOfWorkType {
    var word: SttRepository<WordApiModel, RealmWord> { get }
    var tag: SttRepository<TagApiModel, RealmTag> { get }
    var syncData: SttRepository<SyncDataViewModel, RealmSyncData> { get }
}

class UnitOfWork: UnitOfWorkType {
    
    private lazy var _word = SttRepository<WordApiModel, RealmWord> (singleton: false)
    private lazy var _tag = SttRepository<TagApiModel, RealmTag> (singleton: false)
    private lazy var _syncData = SttRepository<SyncDataViewModel, RealmSyncData> (singleton: true)
    
    var word: SttRepository<WordApiModel, RealmWord> { return _word }
    var tag: SttRepository<TagApiModel, RealmTag> { return _tag }
    var syncData: SttRepository<SyncDataViewModel, RealmSyncData> { return _syncData }
}
