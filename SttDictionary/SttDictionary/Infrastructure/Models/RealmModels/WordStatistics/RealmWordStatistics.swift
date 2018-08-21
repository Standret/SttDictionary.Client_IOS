//
//  RealmWordStatistics.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/7/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

class RealmWordStatistics: BaseRealm, RealmDecodable {
    
    typealias TTarget = WordStatisticsApiModel
    
    @objc dynamic var wordId: String = ""
    
    @objc dynamic var lastAnswer: RealmAnswerData? = RealmAnswerData()
    
    @objc private dynamic var _type = AnswersType.originalCard.rawValue
    var type: AnswersType {
        get { return AnswersType(rawValue: _type)! }
        set { _type = newValue.rawValue }
    }
    
    @objc dynamic var interval: Int = 1
    @objc dynamic var repetition: Int = 0
    @objc dynamic var easiness: Float = 2.5
    
    @objc dynamic var nextRepetition: Date = Date()
    
    func deserialize() -> WordStatisticsApiModel {
        return WordStatisticsApiModel(id: id,
                                      dateCreated: dateCreated,
                                      wordId: wordId,
                                      lastAnswer: lastAnswer?.deserialize(),
                                      type: type,
                                      interval: interval,
                                      repetition: repetition,
                                      easiness: easiness,
                                      nextRepetition: nextRepetition)
    }
}
