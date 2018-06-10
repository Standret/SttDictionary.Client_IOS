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
    var reverseCards: Bool = true
    
    init (word: String, translations: [String]) {
        self.originalWorld = word
        self.translations = translations
    }
    
    convenience init (word: String, translations: [String], reverseCards: Bool) {
        self.init(word: word, translations: translations)
        self.reverseCards = reverseCards
    }
}

class UpdateWordApiModel: DictionaryCodable {
    var id: String!
    var originalWorld: String!
    var translations: [String]!
    var originalStatistics: Statistics!
    var translateStatistics: Statistics?
    
    init(word: String, translations: [String], id: String, originalStatistics: Statistics, translateStatistics: Statistics?) {
        self.originalWorld = word
        self.translations = translations
        self.id = id
        self.originalStatistics = originalStatistics
        self.translateStatistics = translateStatistics
    }
}
