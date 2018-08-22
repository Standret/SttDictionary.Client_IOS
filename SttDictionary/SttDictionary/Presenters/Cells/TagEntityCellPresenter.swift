//
//  TagEntityCellPresenter.swift
//  SttDictionary
//
//  Created by Standret on 21.08.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol TagEntityCellDelegate: SttViewable {
    func reloadState()
}

class TagEntityCellPresenter: SttPresenter<TagEntityCellDelegate> {
    
    weak var itemDelegate: WordItemDelegate?
    
    var id: String!
    var name: String!
    var wordCount: Int!
    var isSelect: Bool = false
    
    convenience required init(fromObject: TagApiModel) {
        self.init()
        id = fromObject.id
        name = fromObject.name
        wordCount = fromObject.wordsId.count
    }
    
    func onClick() {
        isSelect = !isSelect
        delegate?.reloadState()
        itemDelegate?.onClick(id: id, name: name)
    }
}
