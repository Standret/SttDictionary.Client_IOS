//
//  Word.swift
//  SttDictionary
//
//  Created by Admin on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

struct TagApiModel: Decodable, RealmCodable {
    func serialize() {
        
    }
    
    let id: String
    let name: String
    let wordsId: [String]
    let dateCreated: Date
}

struct ShortTagApiModel: Decodable {
    let id: String
    let name: String
}
