//
//  DateConverter.swift
//  SttDictionary
//
//  Created by Standret on 5/20/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

fileprivate class DateFormatFactory {
    enum DateFormatType {
        case generalDate
        case exactlyMinuteDay
    }
    
    public class func getFormat(type: DateFormatType) -> String {
        var formatStr: String!
        switch type {
        case .exactlyMinuteDay: formatStr = "dd-MMM-yy HH:mm"
        case .generalDate: formatStr = "dd-MMM-yy"
        }
        return formatStr
    }
    
    public static func getDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
}

class DateConverter: SttConverterType {
    
    typealias TIn = Date
    typealias TOut = String
    
    func convert(value: Date, parametr: Any?) -> String {
        let formatter = DateFormatFactory.getDateFormatter()
        formatter.dateFormat = DateFormatFactory.getFormat(type: .exactlyMinuteDay)
        return formatter.string(from: value)
    }
}

class ShortDateConverter: SttConverterType {
    
    typealias TIn = Date
    typealias TOut = String
    
    func convert(value: Date, parametr: Any?) -> String {
        let formatter = DateFormatFactory.getDateFormatter()
        formatter.dateFormat = DateFormatFactory.getFormat(type: .generalDate)

        return formatter.string(from: value.toLocalTime())
    }
}
