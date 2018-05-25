//
//  AddWordApiModel.swift
//  SttDictionary
//
//  Created by Standret on 5/20/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol DictionaryCodable: Codable {
    
}

class AddWordApiModel: DictionaryCodable {
    let originalWorld: String
    let translations: [String]
    
    init (word: String, translations: [String]) {
        self.originalWorld = word
        self.translations = translations
    }
}
