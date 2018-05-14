//
//  RealmWord.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RealmSwift
import SINQ

class RealmWord: BaseRealm, RealmDecodable {
    
    typealias TTarget = WordApiModel
    
    @objc dynamic var originalWorld: String = ""
    let translations = List<RealmString>()
    let additionalTranslate = List<RealmString>()
    let imageUrls = List<RealmString>()
    let tags = List<RealmShortTag>()
    
    func deserialize() -> WordApiModel {
        return WordApiModel(id: id, dateCreated: dateCreated, originalWorld: originalWorld, translations: sinq(translations).select { $0.value }.toArray(), additionalTranslations: sinq(additionalTranslate).select { $0.value }.toArray(), tags: sinq(tags).select { ShortTagApiModel(id: $0.id, name: $0.name) }.toArray(), imageUrls: sinq(imageUrls).select { $0.value }.toArray())
    }
}
