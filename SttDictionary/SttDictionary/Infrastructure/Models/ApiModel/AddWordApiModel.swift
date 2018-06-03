//
//  AddWordApiModel.swift
//  SttDictionary
//
//  Created by Standret on 5/20/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol DictionaryCodable: Codable { }

class AddWordApiModel: DictionaryCodable {
    var originalWorld: String!
    var translations: [String]!
    
    init (word: String, translations: [String]) {
        self.originalWorld = word
        self.translations = translations
    }
}

class UpdateWordApiModel: DictionaryCodable {
    var id: String!
    var statistics: Statistics!
    var originalWorld: String!
    var translations: [String]!
    
    init(word: String, translations: [String], id: String, statistics: Statistics) {
        self.originalWorld = word
        self.translations = translations
        self.id = id
        self.statistics = statistics
    }
}
