//
//  RealmWord.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RealmSwift

class RealmExample: Object, RealmDecodable {
   
    typealias TTarget = ExampleUsage
    
    @objc dynamic var original: String = ""
    @objc dynamic var translate: String = ""
    
    func deserialize() -> ExampleUsage {
        return ExampleUsage(original: original, translate: translate)
    }
}

class RealmWord: BaseRealm, RealmDecodable {
    
    typealias TTarget = WordApiModel
    
    @objc dynamic var originalWorld: String = ""
    @objc dynamic var originalStatistics: RealmStatistics? = RealmStatistics()
    @objc dynamic var translateStatistics: RealmStatistics? = RealmStatistics()
    let translations = List<SttRealmString>()
    let additionalTranslate = List<SttRealmString>()
    let imageUrls = List<SttRealmString>()
    let tags = List<RealmShortTag>()
    
    @objc dynamic var pronunciationUrl: String?
    let linkedWords = List<SttRealmString>()
    @objc dynamic var reverseCards: Bool = true
    @objc dynamic var exampleUsage: RealmExample? = RealmExample()
    
    func deserialize() -> WordApiModel {
        return WordApiModel(id: id,
                            dateCreated: dateCreated,
                            originalWorld: originalWorld,
                            translations: translations.map { $0.value },
                            additionalTranslations: additionalTranslate.map { $0.value },
                            tags: tags.map { ShortTagApiModel(id: $0.id, name: $0.name) },
                            imageUrls: imageUrls.map { $0.value },
                            originalStatistics: originalStatistics?.deserialize(),
                            translateStatistics: translateStatistics?.deserialize(),
                            pronunciationUrl: pronunciationUrl,
                            linkedWords: linkedWords.map({ $0.value }),
                            reverseCards: reverseCards,
                            exampleUsage: exampleUsage?.deserialize())
    }
}

