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

class NewWordPresenter: SttPresenter<NewWordDelegate> {
    
    var mainTranslation = [WorldCollectionCellPresenter]()
    
    func addNewMainTranslation(value: String) {
        mainTranslation.append(WorldCollectionCellPresenter(value: value))
        delegate.reloadMainCollectionCell()
    }
}
