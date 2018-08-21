//
//  ExampleUsage.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/5/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

struct ExampleUsage: RealmCodable, Codable {
    
    typealias TTarget = RealmExampleUsage
    
    let original: String
    let translate: String
    
    func serialize() -> RealmExampleUsage {
        return RealmExampleUsage(value: [
            "original": original,
            "translate": translate
            ])
    }
}
