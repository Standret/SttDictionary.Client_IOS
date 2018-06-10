//
//  UnitOfWork.swift
//  SttDictionary
//
//  Created by Standret on 14.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol IUnitOfWork {
    var word: Repository<WordApiModel, RealmWord> { get }
    var tag: Repository<TagApiModel, RealmTag> { get }
    var syncData: Repository<SyncDataViewModel, RealmSyncData> { get }
}

class UnitOfWork: IUnitOfWork {
    
    private lazy var _word = Repository<WordApiModel, RealmWord> (singleton: false)
    private lazy var _tag = Repository<TagApiModel, RealmTag> (singleton: false)
    private lazy var _syncData = Repository<SyncDataViewModel, RealmSyncData> (singleton: true)
    
    var word: Repository<WordApiModel, RealmWord> { return _word }
    var tag: Repository<TagApiModel, RealmTag> { return _tag }
    var syncData: Repository<SyncDataViewModel, RealmSyncData> { return _syncData }
}
