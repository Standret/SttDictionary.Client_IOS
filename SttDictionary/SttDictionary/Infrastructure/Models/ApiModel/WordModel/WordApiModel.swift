//
//  WordApiModel.swift
//  SttDictionary
//
//  Created by Admin on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

struct WordApiModel: Decodable, RealmCodable {
    typealias TTarget = RealmWord

    let id: String!
    let dateCreated: Date
    
    let pronunciationUrl: String?
    let exampleUsage: ExampleUsage?
    
    let originalWorld: String
    let translations: [String]
    let tags: [ShortTagApiModel]?
    let linkedWords: [String]?
    
    let reverseCards: Bool
    let usePronunciation: Bool
    
    func serialize() -> TTarget {
        let model = RealmWord(value: [
            "isSynced": id == nil ? false : true,
            "id": id ?? "\(Constants.temporyPrefix)\(UUID().uuidString)",
            "dateCreated": dateCreated, 
            "pronunciationUrl": pronunciationUrl,
            "exampleUsage": exampleUsage?.serialize(),
            "originalWorld": originalWorld,
            "reverseCards": reverseCards,
            "usePronunciation": usePronunciation
            ])
        
        model.translations.append(objectsIn: translations.map( { SttRealmString(value: [$0]) }))
        
        if let _tags = tags {
            model.tags.append(objectsIn: _tags.map( { RealmShortTag(value: ["id": $0.id, "name": $0.name ]) }))
        }
        if let linkedWords = linkedWords {
            model.linkedWords.append(objectsIn: linkedWords.map( { SttRealmString(value: [$0]) }))
        }
        
        return model
    }
}

