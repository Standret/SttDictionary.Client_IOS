//
//  Word.swift
//  SttDictionary
//
//  Created by Admin on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RealmSwift
import SINQ

struct TagApiModel: Decodable, RealmCodable {
   
    typealias TTarget = RealmTag
    
    let id: String
    let dateCreated: Date

    let name: String
    let wordsId: [String]
    
    func serialize() -> RealmTag {
        let realm = try! Realm()
        let words =  sinq(wordsId.map { realm.object(ofType: RealmWord.self, forPrimaryKey: $0) }).whereTrue( { $0 != nil } ).toArray()
        return RealmTag(value: [
            "id": id,
            "dateCreated": dateCreated,
            "name": name,
            "word": words
            ])
    }
}
