//
//  Tag.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RealmSwift

class RealmTag: BaseRealm, RealmDecodable {
    func deserialize() -> TagApiModel {
        var ids = [String]()
        for item in word {
            ids.append(item.id)
        }
        return TagApiModel(id: id, name: name, wordsId: ids, dateCreated: dateCreated)
    }
    
    typealias TTarget = TagApiModel
    
    @objc dynamic var name: String = ""
    let word = List<RealmWord>()
}
