//
//  RealmWord.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RealmSwift

class RealmWord: BaseRealm {
    @objc dynamic var originalWorld: String = ""
    let translations = List<RealmString>()
    let additionalTranslate = List<RealmString>()
    let imageUrls = List<RealmString>()
    let tags = List<RealmShortTag>()
}
