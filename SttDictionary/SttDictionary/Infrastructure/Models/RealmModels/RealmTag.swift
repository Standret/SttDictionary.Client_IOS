//
//  Tag.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RealmSwift

class RealmTag: BaseRealm {
    @objc dynamic var name: String = ""
    let word = List<RealmWord>()
}
