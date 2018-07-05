//
//  ShortTagApiModel.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/5/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

struct ShortTagApiModel: Decodable, RealmCodable {
    
    typealias TTarget = RealmShortTag
    
    let id: String
    let name: String
    
    func serialize() -> RealmShortTag {
        return RealmShortTag(value: [
            "id": id,
            "name": name
            ])
    }
}
