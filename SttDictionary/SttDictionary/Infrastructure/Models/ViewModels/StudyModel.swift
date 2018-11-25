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
    
    init(newOriginal: [WordApiModel], newTranslate: [WordApiModel],
         repeatOriginal: [WordApiModel], repeatTranslation: [WordApiModel]) {
        
        self.newOriginal = newOriginal
        self.newTranslate = newTranslate
        self.repeatOriginal = repeatOriginal
        self.repeatTranslation = repeatTranslation
    }
}

enum ResultType {
    case newOriginal, newTranslation
    case repeatOriginal, repeatTranslation
}

class LocalWordsResult {
    
    let type: ResultType
    let words: [WordApiModel]
    
    init(type: ResultType, words: [WordApiModel]) {
        
        self.type = type
        self.words = words
    }
}
