//
//  DateConverter.swift
//  SttDictionary
//
//  Created by Standret on 5/20/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

class DateConverter: IConverter {
    
    typealias TIn = Date
    typealias TOut = String
    
    func convert(value: Date, parametr: Any?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MMM-dd HH:mm:ss"
        
        return formatter.string(from: value)
    }
}
