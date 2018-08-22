//
//  ConverterToApiModel.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/6/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RealmSwift

extension AddWordApiModel {
    func convertToApiModel() throws -> WordApiModel {
        let realm = try Realm()
        let tags =  self.tagsId?.map({ realm.object(ofType: RealmShortTag.self, forPrimaryKey: $0)! }).map({ $0.deserialize() })
        return WordApiModel(id: nil,
                            dateCreated: Date(),
                            pronunciationUrl: self.pronunciationUrl,
                            exampleUsage: self.exampleUsage,
                            explanation: explanation,
                            originalWorld: self.originalWorld,
                            translations: self.translations,
                            tags: tags,
                            linkedWords: self.linkedWords,
                            reverseCards: self.reverseCards,
                            usePronunciation: self.usePronunciation)
    }
}

extension RealmWord {
    func convertToApiModel() -> AddWordApiModel {
        return AddWordApiModel(word: self.originalWorld,
                               translations: self.translations.map({ $0.value }),
                               pronunciationUrl: self.pronunciationUrl,
                               exampleUsage: self.exampleUsage?.deserialize(),
                               tagsId: self.tags.map({ $0.id }),
                               linkedWords: self.linkedWords.map({ $0.value }),
                               reverseCards: self.reverseCards,
                               usePronunciation: self.usePronunciation,
                               explanation: explanation)
    }
}

extension RealmAnswer {
    func convertToApiModel() -> AnswerDataApiModel {
        return AnswerDataApiModel(answer: self.grade,
                                  type: self.type,
                                  raw: self.raw,
                                  date: self.dateCreated,
                                  miliSecondsForReview: self.miliSecondsForReview)
    }
}
