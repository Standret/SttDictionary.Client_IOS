//
//  BaseRealm.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RealmSwift

class SttRealmObject: Object {
    @objc dynamic var id: String = Constants.keySingle
    @objc dynamic var dateCreated: Date = Date()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class SttRealmString: Object {
    @objc dynamic var value: String = ""
}
