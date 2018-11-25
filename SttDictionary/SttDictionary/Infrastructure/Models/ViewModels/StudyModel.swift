//
//  StudyModel.swift
//  SttDictionary
//
//  Created by Piter Standret on 11/25/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

class StudyWordsModel {
    
    let newOriginal: [WordApiModel]
    let newTranslate: [WordApiModel]
    let repeatOriginal: [WordApiModel]
    let repeatTranslation: [WordApiModel]
    let extraordinaryOriginal: [ExtraordinaryModel]
    let extraordinaryTranslation: [ExtraordinaryModel]
    
    init(newOriginal: [WordApiModel], newTranslate: [WordApiModel],
         repeatOriginal: [WordApiModel], repeatTranslation: [WordApiModel],
         extraordinaryOriginal: [ExtraordinaryModel], extraordinaryTranslation: [ExtraordinaryModel]) {
        
        self.newOriginal = newOriginal
        self.newTranslate = newTranslate
        self.repeatOriginal = repeatOriginal
        self.repeatTranslation = repeatTranslation
        self.extraordinaryOriginal = extraordinaryOriginal
        self.extraordinaryTranslation = extraordinaryTranslation
    }
}

enum ResultType {
    case newOriginal, newTranslation
    case repeatOriginal, repeatTranslation
    case extraordinaryOriginal, extraordinaryTranslate
}

class LocalWordsResult {
    
    let type: ResultType
    let words: [WordApiModel]?
    let extraordinary: [ExtraordinaryModel]?
    
    init(type: ResultType, words: [WordApiModel]? = nil, extraordinary: [ExtraordinaryModel]? = nil) {
        
        self.type = type
        self.words = words
        self.extraordinary = extraordinary
    }
}

class ExtraordinaryModel {
    
    let word: WordApiModel
    var preferDate: Date // todo: delete
    var after: Int?
    var interval: Int?
    
    init (word: WordApiModel, date: Date) {
        self.word = word
        self.preferDate = date
    }
}
