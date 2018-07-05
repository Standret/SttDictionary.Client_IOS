//
//  WordStatisticsApiModel.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/5/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

struct WordStatisticsApiModel: Decodable {
    
    let id: String
    let dateCreated: Date
    
    let wordsId: String
    let lastAnswer: AnswerDataApiModel
    let type: AnswersType
    
    let interval: Int
    let repetition: Int
    let easiness: Int
    
    let nextRepetition: Date
}
