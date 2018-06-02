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
    }
}
