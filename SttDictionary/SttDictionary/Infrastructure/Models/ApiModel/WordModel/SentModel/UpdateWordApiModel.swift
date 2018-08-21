//
//  UpdateWordApiModel.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/5/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

class UpdateWordApiModel: Codable {
    var id: String!
    
    var originalWorld: String!
    var translations: [String]!
    
    var pronunciationUrl: String?
    var exampleUsage: ExampleUsage?
    
    var tagsId: [String]?
    var linkedWords: [String]?
    
    var reverseCards: Bool = true
    var usePronunciation: Bool = true
    
    init (id: String,
          word: String,
          translations: [String],
          pronunciationUrl: String? = nil,
          exampleUsage: ExampleUsage? = nil,
          tagsId: [String]? = nil,
          linkedWords: [String]? = nil,
          reverseCards: Bool = true,
          usePronunciation: Bool = true) {
        
        self.id = id
        
        self.originalWorld = word
        self.translations = translations
        
        self.pronunciationUrl = pronunciationUrl
        self.exampleUsage = exampleUsage
        
        self.tagsId = tagsId
        self.linkedWords = linkedWords
        
        self.reverseCards = reverseCards
        self.usePronunciation = usePronunciation
    }
}
