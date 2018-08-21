//
//  TagEntityCellPresenter.swift
//  SttDictionary
//
//  Created by Standret on 21.08.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol TagEntityCellDelegate: SttViewable { }

class  TagEntityCellPresenter: SttPresenter<TagEntityCellDelegate> {
        
    var name: String!
    var wordCount: Int!
    
    convenience required init(fromObject: TagApiModel) {
        self.init()
        name = fromObject.name
        wordCount = fromObject.wordsId.count
    }
    
//    func onClick() {
//        isSelect = !isSelect
//        itemDelegate?.onClick(id: id, name: word)
//    }
}
