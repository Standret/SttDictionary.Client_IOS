//
//  RealmSyncData.swift
//  SttDictionary
//
//  Created by Admin on 5/20/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

class RealmSyncData: BaseRealm, RealmDecodable {
    
    typealias TTarget = SyncDataViewModel
    
    @objc dynamic var dateOfLastSync: Date = Date()
    @objc dynamic var countLocal: Int = 0
    @objc dynamic var countServer: Int = 0
    
    func deserialize() -> SyncDataViewModel {
        return SyncDataViewModel(date: dateOfLastSync, countLocal: countLocal, countServer: countServer)
    }
}
