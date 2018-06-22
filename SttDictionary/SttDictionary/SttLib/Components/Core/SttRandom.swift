//
//  SttRandom.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/3/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

class SttRandom {
    class func boolRandom(k: Int) -> Bool {
        let _k = UInt32(4 - k)
        return arc4random_uniform(_k) == 0
    }
    
    class func radomIndex(start: UInt32, end: UInt32, count: Int) -> [Int] {
        var res = [Int]()
        while res.count < count {
            let newValue = arc4random_uniform(end)
            if newValue < start || res.contains(Int(newValue)) {
                continue
            }
            res.append(Int(newValue))
        }
        return res
    }
}
