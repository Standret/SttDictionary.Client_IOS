//
//  AddWordApiModel.swift
//  SttDictionary
//
//  Created by Standret on 5/20/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

class AddWordApiModel: Codable {
    var originalWorld: String!
    var translations: [String]!
    
    var linkedWords: [String]?
    var reverseCards: Bool = true
    var pronunciationUrl: String?
    var exampleUsage: ExampleUsage?
    
    init (word: String, translations: [String], linkedWords: [String]?, reverseCards: Bool = true, pronunciationUrl: String? = nil, exampleUsage: ExampleUsage? = nil) {
        self.originalWorld = word
        self.translations = translations
        self.linkedWords = linkedWords
        self.reverseCards = reverseCards
        self.pronunciationUrl = pronunciationUrl
        self.exampleUsage = exampleUsage
    }
}

class UpdateWordApiModel: Codable {
    var id: String!
    var originalWorld: String!
    var translations: [String]!
    var originalStatistics: Statistics!
    var translateStatistics: Statistics?
    
    var linkedWords: [String]?
    var reverseCards: Bool = true
    var pronunciationUrl: String?
    var exampleUsage: ExampleUsage?
    
    init(word: String, translations: [String], id: String, originalStatistics: Statistics, translateStatistics: Statistics?,
         linkedWords: [String]?, reverseCards: Bool = true, pronunciationUrl: String? = nil, exampleUsage: ExampleUsage? = nil) {
        self.originalWorld = word
        self.translations = translations
        self.id = id
        self.originalStatistics = originalStatistics
        self.translateStatistics = translateStatistics
        self.linkedWords = linkedWords
        self.reverseCards = reverseCards
        self.pronunciationUrl = pronunciationUrl
        self.exampleUsage = exampleUsage
    }
}
