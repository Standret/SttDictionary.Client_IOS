//
//  AnswerApiModel.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/5/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

struct AnswerApiModel: Decodable, RealmCodable {
    
    typealias TTarget = RealmAnswer
    
    let id: String
    let dateCreated: Date
    
    let wordId: String
    let type: AnswersType
    let grade: AnswersGrade
    let miliSecondsForReview: Int
    
    func serialize() -> RealmAnswer {
        return RealmAnswer(value: [
            "id": id,
            "dateCreated": dateCreated,
            "wordId": wordId,
            "_type": type.rawValue,
            "_grade": grade.rawValue,
            "miliSecondsForReview": miliSecondsForReview
            ])
    }
}
