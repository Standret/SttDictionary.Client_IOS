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
    
    var word: String!
    var mainTranslations: String!
    var tags: String!
    var status: Bool!
    
    convenience init (element: WordApiModel) {
        self.init()
        word = element.originalWorld
        mainTranslations = element.translations.joined(separator: (", "))
        tags = (element.tags?.map({ element in "#\(element.name)" }).joined(separator: ", ") ?? "")
        if tags.isEmpty {
            tags = "#none"
        }
    }
    required init() { }
}
