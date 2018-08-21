//
//  ApiModel.swift
//  SttDictionary
//
//  Created by Standret on 21.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

struct ServerError: Decodable {
    let code: Int
    let description: String
}

struct ServiceResult: Decodable {
    let error: ServerError
}
