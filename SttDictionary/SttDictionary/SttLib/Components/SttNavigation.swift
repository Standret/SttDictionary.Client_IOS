//
//  SttNavigation.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/22/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

enum TypeNavigation {
    case push
    case modality
}

protocol SttStoryboardType {
    func getName() -> String
}
