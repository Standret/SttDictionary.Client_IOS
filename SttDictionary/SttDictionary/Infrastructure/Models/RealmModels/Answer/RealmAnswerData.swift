//
//  RealmAnswerData.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/7/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RealmSwift

class RealmAnswerData: Object, RealmDecodable {
    
    typealias TTarget = AnswerDataApiModel
    
    @objc dynamic var miliSecondsForReview: Int = 0
    @objc dynamic var date: Date = Date()
    
    @objc private dynamic var _answer = AnswersGrade.forget.rawValue
    var answer: AnswersGrade {
        get { return AnswersGrade(rawValue: _answer)! }
        set { _answer = newValue.rawValue }
    }
    
    @objc private dynamic var _type = AnswersType.originalCard.rawValue
    var type: AnswersType {
        get { return AnswersType(rawValue: _type)! }
        set { _type = newValue.rawValue }
    }
    
    @objc private dynamic var _raw = AnswersRaw.forget.rawValue
    var raw: AnswersRaw {
        get { return AnswersRaw(rawValue: _raw)! }
        set { _raw = newValue.rawValue }
    }
    
    func deserialize() -> AnswerDataApiModel {
        return AnswerDataApiModel(answer: answer,
                                  type: type,
                                  raw: raw,
                                  date: date,
                                  miliSecondsForReview: miliSecondsForReview)
    }
}
