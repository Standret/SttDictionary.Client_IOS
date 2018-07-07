//
//  RealmAnswer.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/7/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

class RealmAnswer: BaseRealm, RealmDecodable {
    
    typealias TTarget = AnswerApiModel
    
    @objc dynamic var wordId: String = ""
    @objc dynamic var miliSecondsForReview: Int = 0
    
    @objc private dynamic var _grade = AnswersGrade.forget.rawValue
    var grade: AnswersGrade {
        get { return AnswersGrade(rawValue: _grade)! }
        set { _grade = newValue.rawValue }
    }
    
    @objc private dynamic var _type = AnswersType.originalCard.rawValue
    var type: AnswersType {
        get { return AnswersType(rawValue: _type)! }
        set { _type = newValue.rawValue }
    }
    
    @objc private dynamic var _raw = AnswersRaw.hard.rawValue
    var raw: AnswersRaw {
        get { return AnswersRaw(rawValue: _raw)! }
        set { _raw = newValue.rawValue }
    }
    
    func deserialize() -> AnswerApiModel {
        return AnswerApiModel(id: id,
                              dateCreated: dateCreated,
                              wordId: wordId,
                              type: type,
                              grade: grade,
                              miliSecondsForReview: miliSecondsForReview)
    }
}
