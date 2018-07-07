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
    
    class func getWordQuery(text: String) -> CardsPredicate? {
        print (Date().onlyDay())
        let predicateNewCard = NSPredicate(format: "originalStatistics.answers.@count == 0", argumentArray: [])

        let predicateRepeat = NSPredicate(format: "originalStatistics.nextRepetition <= %@ and originalStatistics.answers.@count > 0", argumentArray: [Date().onlyDay()])
        let predicateTranslateCard = NSPredicate(format: "translateStatistics.answers.@count == 0 and reverseCards = true", argumentArray: [])
        let predicateTranslateRepeat = NSPredicate(format: "translateStatistics.nextRepetition <= %@ and translateStatistics.answers.@count > 0 and reverseCards = true", argumentArray: [Date().onlyDay()])
        
        if text.trimmingCharacters(in: .whitespaces) == ":@today" {
            return CardsPredicate(newOriginalCard: predicateNewCard.predicateFormat, repeatOriginalCard: predicateRepeat.predicateFormat, newTranslationCard: predicateTranslateCard.predicateFormat, repeatTranslationCard: predicateTranslateRepeat.predicateFormat)
        }
        else if text.trimmingCharacters(in: .whitespaces) == ":@today:r" {
            return CardsPredicate(newOriginalCard: nil, repeatOriginalCard: predicateRepeat.predicateFormat, newTranslationCard: nil, repeatTranslationCard: predicateTranslateRepeat.predicateFormat)
        }
        else if text.trimmingCharacters(in: .whitespaces) == ":@today:n" {
            return CardsPredicate(newOriginalCard: predicateNewCard.predicateFormat, repeatOriginalCard: nil, newTranslationCard: predicateTranslateCard.predicateFormat, repeatTranslationCard: nil)
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
