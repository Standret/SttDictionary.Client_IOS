//
//  Log.swift
//  SttDictionary
//
//  Created by Standret on 16.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

class SttLog {
    class func trace(message: String, key: String) {
        print("TRACE in \(key): \(message)")
    }
    class func error(message: String, key: String) {
        print ("ERROR in \(key): \(message)")
    }
}
