//
//  NewWordPresenter.swift
//  SttDictionary
//
//  Created by Admin on 5/16/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

protocol NewWordDelegate: Viewable {
    func reloadMainCollectionCell()
    func error(isHidden: Bool)
}

class NewWordPresenter: SttPresenter<NewWordDelegate>, WordItemDelegate {
    
    var word: String? {
        didSet {
            if !(word ?? "").trimmingCharacters(in: .whitespaces).isEmpty {
                _ = _wordService.exists(word: word!).subscribe(onNext: { self.delegate.error(isHidden: !$0) })
            }
        }
    }
    var mainTranslation = [WorldCollectionCellPresenter]()
    var save: SttComand!
    
    var _wordService: IWordService!
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        
        save = SttComand(handler: onSave)
    }
    
    func addNewMainTranslation(value: String) {
        mainTranslation.append(WorldCollectionCellPresenter(value: value, delegate: self))
        delegate.reloadMainCollectionCell()
    }
    
    func onSave() {
        if !(word ?? "").trimmingCharacters(in: .whitespaces).isEmpty && mainTranslation.count > 0 {
        _ = save.useWork(observable: _wordService.createWord(word: word ?? "", translations: mainTranslation.map( { $0.word! } )))
            .subscribe(onNext: { (result) in
                print("successfule saved")
            })
        }
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