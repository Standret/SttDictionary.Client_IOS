//
//  UpdateAnswerApiModel.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/5/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

struct UpdateAnswerApiModel: Codable {
    let answers: [String: [AnswerDataApiModel]]
}
