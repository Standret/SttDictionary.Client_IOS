//
//  StatisticsApiModel.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/2/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

enum AnswersGrade: Int, Decodable, DictionaryCodable {
    case forget, bad, fail, pass, good, perfect
}
enum AnswersType: Int, Decodable, SttDictionaryCodable {
    case originalCard, translateCard
}


struct AnswerData: Decodable, RealmCodable, SttDictionaryCodable {

    typealias TTarget = RealmAnswerData
    
    let miliSecondsForReview: Int
    let date: Date
    let answer: AnswersGrade
    
    func serialize() -> RealmAnswerData {
        let model = RealmAnswerData(value: [
            "miliSecondsForReview": miliSecondsForReview,
            "date": date.onlyDay()
            ])
        model.answer = answer
        return model
    }
}

struct Statistics: Decodable, RealmCodable, SttDictionaryCodable {
    
    typealias TTarget = RealmStatistics
    
    let nextRepetition: Date?
    let easiness: Float
    let repetition: Int
    let interval: Int
    let answers: [AnswerData]
    
    func serialize() -> RealmStatistics {
        return RealmStatistics(value: [
            "nextRepetition": nextRepetition?.onlyDay(),
            "easiness": easiness,
            "repetition": repetition,
            "interval": interval,
            "answers": answers.map( { $0.serialize() } )
            ])
    }
}
