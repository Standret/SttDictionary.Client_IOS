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
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yy-MMM-dd HH:mm:ss"
        
        return formatter.string(from: value)
    }
}

class ShortDateConverter: IConverter {
    
    typealias TIn = Date
    typealias TOut = String
    
    func convert(value: Date, parametr: Any?) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yy-MMM-dd"
        
        return formatter.string(from: value)
    }
}
