//
//  SttIdentifiers.swift
//  YURT
//
//  Created by Standret on 25.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

struct SttIdentifiers {
    let identifers: String
    let nibName: String?
    let isRegistered: Bool
    
    init (identifers: String, nibName: String? = nil, isRegistered: Bool = false) {
        self.identifers = identifers
        self.nibName = nibName
        self.isRegistered = isRegistered
    }
}
