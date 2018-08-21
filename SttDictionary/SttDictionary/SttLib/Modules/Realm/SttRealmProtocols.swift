//
//  RealmProtocols.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/22/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RealmSwift

enum RealmStatus {
    case Updated, Deleted, Inserted
}

protocol RealmCodable {
    associatedtype TTarget: Object, RealmDecodable
    
    func serialize() -> TTarget
}

protocol RealmDecodable {
    associatedtype TTarget
    
    init()
    func deserialize() -> TTarget
}
