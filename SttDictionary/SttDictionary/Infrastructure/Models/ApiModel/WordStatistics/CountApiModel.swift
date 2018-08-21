//
//  CountApiModel.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/7/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

struct CountApiModel: Codable {
    var countOfWords: Int
    var countOfTags: Int
    var countOfStatistics: Int
    var countOfAnswers: Int
}
