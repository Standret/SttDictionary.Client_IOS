//
//  WordEntityCellPresenter.swift
//  SttDictionary
//
//  Created by Admin on 5/20/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol WordEntityCellDelegate: Viewable {
    
}

class WordEntityCellPresenter: SttPresenter<WordEntityCellDelegate> {
    
    typealias TTarget = RealmWord
    
    
    var word: String!
    var mainTranslations: String!
    var tags: String = ""
    var status: Bool = false
    var nextOriginalDate: Date?
    var nextTranslationDate: Date?
    var devInfo: String?
    
    convenience init (element: WordApiModel) {
        self.init()
        word = element.originalWorld
        mainTranslations = element.translations.joined(separator: (", "))
        tags = (element.tags?.map({ element in "#\(element.name)" }).joined(separator: ", ") ?? "")
        if tags.isEmpty {
            tags = "#none"
        }
    }
    convenience required init(fromObject: RealmWord) {
        self.init()
        word = fromObject.originalWorld
        mainTranslations = fromObject.translations.map( { $0.value } ).joined(separator: (", "))
        tags = (fromObject.tags.map( { $0.name } ).map({ "#\($0)" }).joined(separator: ", ") )
        if tags.isEmpty {
            tags = "#none"
        }
        status = fromObject.isSynced
        nextOriginalDate = fromObject.originalStatistics?.nextRepetition
        nextTranslationDate = fromObject.translateStatistics?.nextRepetition
        
        var last = fromObject.originalStatistics?.answers.last
        if let _last = last {
            devInfo = "\(DateConverter().convert(value: _last.date)) \(_last.answer) \(fromObject.originalStatistics!.easiness) i:\(fromObject.originalStatistics!.interval) r: \(fromObject.originalStatistics!.repetition)"
        }
        last = fromObject.translateStatistics?.answers.last
        if let _last = last {
            devInfo = "\(devInfo ?? "--") --||-- \(DateConverter().convert(value: _last.date)) \(_last.answer) \(fromObject.translateStatistics!.easiness) i:\(fromObject.translateStatistics!.interval) r: \(fromObject.translateStatistics!.repetition)"
        }
        else {
            devInfo = "none"
        }
    }
}
