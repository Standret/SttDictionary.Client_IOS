//
//  Tag.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RealmSwift
import SINQ

class RealmTag: BaseRealm, RealmDecodable {
    
    typealias TTarget = TagApiModel
    
    @objc dynamic var name: String = ""
    let word = List<RealmWord>()
    
    func deserialize() -> TagApiModel {
        print("--> \(name) -- \(word.toArray())")
        return TagApiModel(id: id,
                           dateCreated: dateCreated,
                           name: name,
                           wordsId: word.map { $0.id } )
    }
}
