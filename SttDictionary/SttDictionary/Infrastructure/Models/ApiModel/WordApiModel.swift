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

    func serialize() -> TTarget {
        let model = RealmWord(value: ["isSynced": id == nil ? false : true,  "id": id == nil ? UUID().uuidString : id, "dateCreated": dateCreated, "originalWorld": originalWorld])
        model.translations.append(objectsIn: translations.map( { RealmString(value: [$0]) }))
        if let additionalTrans = additionalTranslations {
            model.additionalTranslate.append(objectsIn: additionalTrans.map( { RealmString(value: [$0]) }))
        }
        if let _tags = tags {
            model.tags.append(objectsIn: _tags.map( { RealmShortTag(value: ["id": $0.id, "name": $0.name ]) }))
        }
        if let imgs = imageUrls {
            model.imageUrls.append(objectsIn: imgs.map( { RealmString(value: [$0]) }))
        }
        
        return model
    }

    let id: String?
    let dateCreated: Date
    let originalWorld: String
    let translations: [String]
    let additionalTranslations: [String]?
    let tags: [ShortTagApiModel]?
    let imageUrls: [String]?
}

