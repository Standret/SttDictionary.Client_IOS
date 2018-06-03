//
//  QueryFactories.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/2/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

struct CardsPredicate {
    let newCard: String?
    let repeatCard: String?
}

class QueryFactories {
    
    class func getWordQuery(text: String) -> CardsPredicate? {
        print (Date().onlyDay())
        let predicateNewCard = NSPredicate(format: "statistics.answers.@count == 0", argumentArray: [Date().onlyDay()])
        let predicateRepeat = NSPredicate(format: "statistics.nextRepetition <= %@ and statistics.answers.@count > 0", argumentArray: [Date().onlyDay()])
        
        if text.trimmingCharacters(in: .whitespaces) == ":@today" {
            return CardsPredicate(newCard: predicateNewCard.predicateFormat, repeatCard: predicateRepeat.predicateFormat)
        }
        else if text.trimmingCharacters(in: .whitespaces) == ":@today:r" {
            return CardsPredicate(newCard: nil, repeatCard: predicateRepeat.predicateFormat)
        }
        else if text.trimmingCharacters(in: .whitespaces) == ":@today:n" {
            return CardsPredicate(newCard: predicateNewCard.predicateFormat, repeatCard: nil)
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
