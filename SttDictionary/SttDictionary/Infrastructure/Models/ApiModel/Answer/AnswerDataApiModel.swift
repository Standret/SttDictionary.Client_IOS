//
//  AnswerDataApiModel.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/5/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

struct AnswerDataApiModel: Codable {
    
    let answer: AnswersGrade
    let type: AnswersType
    let raw: AnswersRaw
    
    let date: Date
    let miliSecondsForReview: Int
}
