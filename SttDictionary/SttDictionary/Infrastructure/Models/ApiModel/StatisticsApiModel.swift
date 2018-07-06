//
//  StatisticsApiModel.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/2/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

struct Statistics: RealmCodable, Codable {
    
    typealias TTarget = RealmStatistics
    
    let nextRepetition: Date?
    let easiness: Float
    let repetition: Int
    let interval: Int
    let answers: [AnswerDataApiModel]
    
    func serialize() -> RealmStatistics {
        return RealmStatistics(
//            "nextRepetition": nextRepetition?.onlyDay(),
//            "easiness": easiness,
//            "repetition": repetition,
//            "interval": interval,
//            "answers": answers.map( { $0.serialize() } )
            )
    }
}
