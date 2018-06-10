//
//  SyncData.swift
//  SttDictionary
//
//  Created by Standret on 5/20/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

class SyncDataViewModel: RealmCodable, Defaultable {
    
    typealias TTarget = RealmSyncData
    
    var dateOfLastSync: Date
    var countLocal: Int
    var countServer: Int
    
    init (date: Date, countLocal: Int, countServer: Int) {
        self.dateOfLastSync = date
        self.countLocal = countLocal
        self.countServer = countServer
    }
    
    required convenience init() {
        self.init(date: Date(), countLocal: 0, countServer: 0)
    }
    
    func serialize() -> RealmSyncData {
        return RealmSyncData(value: ["dateOfLastSync": dateOfLastSync, "countLocal": countLocal, "countServer": countServer])
    }
}
