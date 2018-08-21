//
//  AnswerEnums.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/5/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

enum AnswersGrade: Int, Codable {
    case forget, bad, fail, pass, good, perfect
}

enum AnswersType: Int, Codable {
    case originalCard, translateCard, rule
}

enum AnswersRaw: Int, Codable {
    case forget, hard, easy
}
