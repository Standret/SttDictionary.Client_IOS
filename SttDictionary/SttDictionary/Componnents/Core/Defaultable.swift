//
//  Defaultable.swift
//  SttDictionary
//
//  Created by Standret on 5/20/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol Defaultable {
    init()
}

class FactoryDefaultsObject {
    class func create<T: Defaultable>(ofType _: T.Type) -> T {
        return T()
    }
}
