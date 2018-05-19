//
//  NewWordPresenter.swift
//  SttDictionary
//
//  Created by Admin on 5/16/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol NewWordDelegate: Viewable {
    func reloadMainCollectionCell()
}

class NewWordPresenter: SttPresenter<NewWordDelegate>, WordItemDelegate {
    
    var mainTranslation = [WorldCollectionCellPresenter]()
    
    func addNewMainTranslation(value: String) {
        mainTranslation.append(WorldCollectionCellPresenter(value: value, delegate: self))
        delegate.reloadMainCollectionCell()
    }
    
    func deleteItem(word: String?) {
        let _index = mainTranslation.index { (element) -> Bool in
            if element.word == word {
                return true
            }
            return false
        }
        
        if let index = _index {
            mainTranslation.remove(at: index)
            delegate.reloadMainCollectionCell()
        }
    }
}
