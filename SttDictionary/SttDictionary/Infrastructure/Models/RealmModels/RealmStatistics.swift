//
//  RealmStatistics.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/2/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RealmSwift

class RealmStatistics: Object, RealmDecodable {
    
    typealias TTarget = Statistics
    
    @objc dynamic var nextRepetition: Date? = Date()
    @objc dynamic var easiness: Float = 2.5
    @objc dynamic var repetition: Int = 0
    @objc dynamic var interval: Int = 1
    let answers = List<RealmAnswerData>()
    
    func deserialize() -> Statistics {
        return Statistics(nextRepetition: nextRepetition, easiness: easiness, repetition: repetition, interval: interval, answers: answers.map { $0.deserialize() } )
    }
}

class RealmAnswerData: Object, RealmDecodable {
    
    typealias TTarget = AnswerData
    
    @objc dynamic var miliSecondsForReview: Int = 0
    @objc dynamic var date: Date = Date()
    
    @objc private dynamic var _answer = AnswersGrade.forget.rawValue
    @objc private dynamic var _type = AnswersType.originalCard.rawValue
    
    var answer: AnswersGrade {
        get { return AnswersGrade(rawValue: _answer)! }
        set { _answer = newValue.rawValue }
    }
    var type: AnswersType {
        get { return AnswersType(rawValue: _type)! }
        set { _type = newValue.rawValue }
    }
    
    func deserialize() -> AnswerData {
        return AnswerData(miliSecondsForReview: miliSecondsForReview, date: date, answer: answer, type: type)
    }
}
