//
//  BaseRealm.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/22/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

class BaseRealm: SttRealmObject {
    @objc dynamic var dateUpdated: Date = Date()
    @objc dynamic var isSynced: Bool = true
}
