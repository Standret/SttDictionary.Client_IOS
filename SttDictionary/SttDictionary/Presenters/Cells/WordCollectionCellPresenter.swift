//
//  WordCollectionCellPresenter.swift
//  SttDictionary
//
//  Created by Standret on 19.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol WordItemDelegate {
    func deleteItem(word: String?)
}

protocol WordCollectionCellDelegate: Viewable {
    
}

class WorldCollectionCellPresenter: SttPresenter<WordCollectionCellDelegate>, RealmInitable {
    
    var word: String?
    
    var collectionDelegate: WordItemDelegate!
    convenience init(value: String, delegate: WordItemDelegate) {
        self.init()
        word = value
        collectionDelegate = delegate
    }
    required init() { }
    convenience required init<TTarget>(fromObject: TTarget) where TTarget : BaseRealm {
        self.init()
    }
    
    func deleteClick() {
        collectionDelegate.deleteItem(word: word)
    }
}
