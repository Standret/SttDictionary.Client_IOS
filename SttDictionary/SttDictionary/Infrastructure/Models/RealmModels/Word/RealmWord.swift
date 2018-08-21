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
    @objc dynamic var pronunciationUrl: String?
    @objc dynamic var exampleUsage: RealmExampleUsage? = RealmExampleUsage()
    
    let translations = List<SttRealmString>()
    let tags = List<RealmShortTag>()
    let linkedWords = List<SttRealmString>()
    
    @objc dynamic var reverseCards: Bool = true
    @objc dynamic var usePronunciation: Bool = true
    
    func deserialize() -> WordApiModel {
        return WordApiModel(id: id,
                            dateCreated: dateCreated,
                            pronunciationUrl: pronunciationUrl,
                            exampleUsage: exampleUsage?.deserialize(),
                            originalWorld: originalWorld,
                            translations: translations.map { $0.value },
                            tags: tags.map { ShortTagApiModel(id: $0.id, name: $0.name) },
                            linkedWords: linkedWords.map { $0.value },
                            reverseCards: reverseCards,
                            usePronunciation: usePronunciation)
    }
}

