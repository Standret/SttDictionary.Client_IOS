//
//  AnswerDataApiModel.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/5/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

struct AnswerDataApiModel: Codable, RealmCodable {
    
    typealias TTarget = RealmAnswerData
    
    let answer: AnswersGrade
    let type: AnswersType
    let raw: AnswersRaw
    
    let date: Date
    let miliSecondsForReview: Int
    
    
    func serialize() -> RealmAnswerData {
        return RealmAnswerData(value: [
            "_answer": answer.rawValue,
            "_type": type.rawValue,
            "_raw": raw.rawValue,
            "date": date,
            "miliSecondsForReview": miliSecondsForReview
            ])
    }
}
