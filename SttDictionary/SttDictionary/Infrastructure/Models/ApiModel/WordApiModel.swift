//
//  WordApiModel.swift
//  SttDictionary
//
//  Created by Admin on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

struct ExampleUsage: RealmCodable, Codable {
   
    typealias TTarget = RealmExample
    
    let original: String
    let translate: String
    
    func serialize() -> RealmExample {
        return RealmExample(value: [
            "original": original,
            "translate": translate
            ])
    }
}

struct WordApiModel: Decodable, RealmCodable {
    typealias TTarget = RealmWord

    let id: String?
    let dateCreated: Date
    let originalWorld: String
    let translations: [String]
    let additionalTranslations: [String]?
    let tags: [ShortTagApiModel]?
    let imageUrls: [String]?
    let originalStatistics: Statistics?
    let translateStatistics: Statistics?
    
    let pronunciationUrl: String?
    let linkedWords: [String]?
    let reverseCards: Bool
    let exampleUsage: ExampleUsage?
    
    func serialize() -> TTarget {
        let model = RealmWord(value: [
            "isSynced": id == nil ? false : true,
            "id": id ?? "\(Constants.temporyPrefix)\(UUID().uuidString)",
            "dateCreated": dateCreated,
            "originalWorld": originalWorld,
            "originalStatistics": originalStatistics!.serialize(),
            "translateStatistics": translateStatistics!.serialize(),
            "pronunciationUrl": pronunciationUrl,
            "reverseCards": reverseCards,
            "exampleUsage": exampleUsage?.serialize()
            ])
        model.translations.append(objectsIn: translations.map( { SttRealmString(value: [$0]) }))
        
        if let additionalTrans = additionalTranslations {
            model.additionalTranslate.append(objectsIn: additionalTrans.map( { SttRealmString(value: [$0]) }))
        }
        if let _tags = tags {
            model.tags.append(objectsIn: _tags.map( { RealmShortTag(value: ["id": $0.id, "name": $0.name ]) }))
        }
        if let imgs = imageUrls {
            model.imageUrls.append(objectsIn: imgs.map( { SttRealmString(value: [$0]) }))
        }
        if let linkedWords = linkedWords {
            model.linkedWords.append(objectsIn: linkedWords.map( { SttRealmString(value: [$0]) }))
        }
        
        return model
    }
}

