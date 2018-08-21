//
//  RealmExampleUsage.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/5/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RealmSwift

class RealmExampleUsage: Object, RealmDecodable {
    
    typealias TTarget = ExampleUsage
    
    @objc dynamic var original: String = ""
    @objc dynamic var translate: String = ""
    
    func deserialize() -> ExampleUsage {
        return ExampleUsage(original: original, translate: translate)
    }
}
