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
        return RealmWord()
    }

    let id: String
    let dateCreated: Date
    let originalWorld: String
    let translations: [String]
    let additionalTranslations: [String]?
    let tags: [ShortTagApiModel]?
    let imageUrls: [String]?
}

