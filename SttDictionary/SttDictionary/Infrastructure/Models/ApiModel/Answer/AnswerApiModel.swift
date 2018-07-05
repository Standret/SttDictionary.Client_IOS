//
//  AnswerApiModel.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/5/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

struct AnswerApiModel: Decodable {
    
    let id: String
    let dateCreated: Date
    
    let wordsId: String
    let type: AnswersType
    let grade: AnswersGrade
    let miliSecondsForReview: Int
}
