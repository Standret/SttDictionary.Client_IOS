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
        return TagApiModel(id: id,
                           name: name,
                           wordsId: sinq(word).select { $0.id }.toArray(),
                           dateCreated: dateCreated)
    }
}
