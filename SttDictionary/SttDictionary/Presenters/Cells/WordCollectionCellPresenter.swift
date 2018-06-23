//
//  WordCollectionCellPresenter.swift
//  SttDictionary
//
//  Created by Standret on 19.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol ShortWordItemDelegate: class {
    func deleteItem(word: String?)
}

protocol WordCollectionCellDelegate: SttViewable {
    
}

class WorldCollectionCellPresenter: SttPresenter<WordCollectionCellDelegate> {
    
    var word: String?
    var id: String?
    
    weak var collectionDelegate: ShortWordItemDelegate!
    convenience init(value: String, delegate: ShortWordItemDelegate) {
        self.init()
        word = value.trimmingCharacters(in: .whitespaces)
        collectionDelegate = delegate
    }
    convenience init(value: String, id: String, delegate: ShortWordItemDelegate) {
        self.init(value: value, delegate: delegate)
        self.id = id
    }
    
    func deleteClick() {
        collectionDelegate.deleteItem(word: word)
    }
}
