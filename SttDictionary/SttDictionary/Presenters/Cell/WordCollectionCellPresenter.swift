//
//  WordCollectionCellPresenter.swift
//  SttDictionary
//
//  Created by Standret on 19.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol WordCollectionCellDelegate: Viewable {
    
}

class WorldCollectionCellPresenter: SttPresenter<WordCollectionCellDelegate> {
    var word: String?
    
    convenience init(value: String) {
        self.init()
        word = value
    }
    
    func deleteClick() {
        
    }
    
    required init() { }
}
