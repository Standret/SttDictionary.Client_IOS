//
//  WordStatisticsApiModel.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/5/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

struct WordStatisticsApiModel: Decodable, RealmCodable {

    typealias TTarget = RealmWordStatistics
    
    let id: String
    let dateCreated: Date
    
    let wordId: String
    let lastAnswer: AnswerDataApiModel?
    let type: AnswersType
    
    let interval: Int
    let repetition: Int
    let easiness: Float
    
    let nextRepetition: Date
    
    func serialize() -> RealmWordStatistics {
        return RealmWordStatistics(value: [
            "id": id,
            "dateCreated": dateCreated,
            "wordId": wordId,
            "lastAnswer": lastAnswer?.serialize(),
            "_type": type.rawValue,
            "interval": interval,
            "repetition": repetition,
            "easiness": easiness,
            "nextRepetition": nextRepetition
            ])
    }
}
