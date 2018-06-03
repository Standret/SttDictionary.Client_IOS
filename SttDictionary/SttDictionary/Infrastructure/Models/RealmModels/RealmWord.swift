//
//  RealmWord.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RealmSwift

class RealmWord: BaseRealm, RealmDecodable {
    
    typealias TTarget = WordApiModel
    
    @objc dynamic var originalWorld: String = ""
    @objc dynamic var statistics: RealmStatistics? = RealmStatistics()
    let translations = List<RealmString>()
    let additionalTranslate = List<RealmString>()
    let imageUrls = List<RealmString>()
    let tags = List<RealmShortTag>()
    
    
    func deserialize() -> WordApiModel {
        return WordApiModel(id: id,
                            dateCreated: dateCreated,
                            originalWorld: originalWorld,
                            translations: translations.map { $0.value },
                            additionalTranslations: additionalTranslate.map { $0.value },
                            tags: tags.map { ShortTagApiModel(id: $0.id, name: $0.name) },
                            imageUrls: imageUrls.map { $0.value },
                            statistics: statistics?.deserialize())
    }
}

