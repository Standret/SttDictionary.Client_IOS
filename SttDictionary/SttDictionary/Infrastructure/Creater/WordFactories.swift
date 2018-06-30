//
//  WordFactories.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/2/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

class WordFactories {
    class func createWordModel(word: String, translations: [String], linkedWords: [String],  useReverse: Bool) -> WordApiModel {
        return WordApiModel(id: nil,
                            dateCreated: Date(),
                            originalWorld: word,
                            translations: translations,
                            additionalTranslations: nil,
                            tags: nil,
                            imageUrls: nil,
                            originalStatistics: WordFactories.defaultStatistics(),
                            translateStatistics: WordFactories.defaultStatistics(),
                            pronunciationUrl: nil,
                            linkedWords: linkedWords,
                            reverseCards: useReverse,
                            exampleUsage: nil)
    }
    
    class func defaultStatistics() -> Statistics {
        return Statistics(nextRepetition: nil, easiness: 2.5, repetition: 0, interval: 1, answers: [])
    }
}
