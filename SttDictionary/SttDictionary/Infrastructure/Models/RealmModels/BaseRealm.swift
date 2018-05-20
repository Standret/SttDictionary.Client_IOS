//
//  BaseRealm.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RealmSwift

class BaseRealm: Object {
    @objc dynamic var id: String = Constants.keySingle
    @objc dynamic var dateCreated: Date = Date()
    @objc dynamic var dateUpdated: Date = Date()
    @objc dynamic var isSynced: Bool = true
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class RealmString: Object {
    @objc dynamic var value: String = ""
}
