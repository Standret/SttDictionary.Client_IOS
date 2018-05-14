//
//  Word.swift
//  SttDictionary
//
//  Created by Admin on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RealmSwift

struct TagApiModel: Decodable, RealmCodable {
   
    typealias TTarget = RealmTag
    
    let id: String
    let name: String
    let wordsId: [String]
    let dateCreated: Date
    
    func serialize() -> RealmTag {
        let realm = try! Realm()
        let words = wordsId.map { realm.object(ofType: RealmWord.self, forPrimaryKey: $0) }
        return RealmTag(value: ["id": id, "dateCreated": dateCreated, "name": name, "word": words])
    }
}

struct ShortTagApiModel: Decodable, RealmCodable {
    
    typealias TTarget = RealmShortTag
    
    let id: String
    let name: String
    
    func serialize() -> RealmShortTag {
        return RealmShortTag(value: ["id": id, "name": name])
    }
}
