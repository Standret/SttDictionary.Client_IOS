//
//  Word.swift
//  SttDictionary
//
//  Created by Admin on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

struct TagApiModel: Decodable, RealmCodable {
   
    typealias TTarget = RealmTag
    

    
    let id: String
    let name: String
    let wordsId: [String]
    let dateCreated: Date
}

struct ShortTagApiModel: Decodable, RealmCodable {
    typealias TTarget = RealmShortTag
    
    let id: String
    let name: String
}
