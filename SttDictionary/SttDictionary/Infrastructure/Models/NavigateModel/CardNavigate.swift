//
//  CardNavigate.swift
//  SttDictionary
//
//  Created by Piter Standret on 11/25/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

class CardNavigate {
    
    let newWords: [WordApiModel]
    let repeatWords: [WordApiModel]
    let extraordinaryWords: [ExtraordinaryModel]
    let type: AnswersType
    
    init (newWords: [WordApiModel], repeatWords: [WordApiModel],
          extraordinaryWords: [ExtraordinaryModel], type: AnswersType) {
        self.newWords = newWords
        self.repeatWords = repeatWords
        self.extraordinaryWords = extraordinaryWords
        self.type = type
    }
}
