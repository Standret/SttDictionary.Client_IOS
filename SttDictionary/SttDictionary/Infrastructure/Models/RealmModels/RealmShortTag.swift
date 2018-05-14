//
//  RealmShortTag.swift
//  SttDictionary
//
//  Created by Admin on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

class RealmShortTag: BaseRealm, RealmDecodable {
    
    typealias TTarget =  ShortTagApiModel
    
    @objc dynamic var name: String = ""
    
    func deserialize() -> ShortTagApiModel {
        return ShortTagApiModel(id: id, name: name)
    }
}
