//
//  QueryFactories.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/2/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

enum ElementType {
    case newNotSynced
    case notSynced
    case all
}

enum StatisticsType {
    case newOriginal, newTranslation
    case repeatOriginal, repeatTranslation
}

struct CardsPredicate {
    let newOriginalCard: String?
    let repeatOriginalCard: String?
    let newTranslationCard: String?
    let repeatTranslationCard: String?
}

class QueryFactories {
    
    /// query for not synced element
    class func getDefaultQuery(type: ElementType) -> String? {
        var result: String?
        switch type {
        case .newNotSynced:
            result = "isSynced == false and id beginswith '\(Constants.temporyPrefix)'"
        case .notSynced:
            result = "isSynced == false and not id beginswith '\(Constants.temporyPrefix)'"
        default: break;
        }
        return result
    }
    
    /// query for get statistics depen on from parametrs "type"
    class func getStatisticsQuery(type: StatisticsType) -> String {
        var predicateString: String!
        switch type {
        case .newOriginal:
            predicateString = "lastAnswer = nil and _type = \(AnswersType.originalCard.rawValue)"
        case .newTranslation:
            predicateString = "lastAnswer = nil and _type = \(AnswersType.translateCard.rawValue)"
        case .repeatOriginal:
            predicateString = NSPredicate(format: "lastAnswer != nil and _type = \(AnswersType.originalCard.rawValue) and nextRepetition <= %@", argumentArray: [Date().onlyDay()]).predicateFormat
        case .repeatTranslation:
            predicateString = NSPredicate(format: "lastAnswer != nil and _type = \(AnswersType.translateCard.rawValue) and nextRepetition <= %@", argumentArray: [Date().onlyDay()]).predicateFormat
        }
        
        return predicateString
    }
    
    /// query for search word in DB
    class func getWordQuery(text: String?) -> String? {
        if (text ?? "").starts(with: ":@") {
            return nil
        }
        if !(text ?? "").isEmpty {
            return "originalWorld contains[cd] '\(text!)' or any translations.value contains[cd] '\(text!)'"
        }
        return nil
    }
    
    class func getTagQuery(text: String?) -> String? {
        if !(text ?? "").isEmpty {
            return "name contains[cd] '\(text!)'"
        }
        return nil
    }
    
    class func isRegisterSchem(scheme: String) -> Bool {
        if scheme.starts(with: ":@today") {
            return true
        }
        return false
    }
}
