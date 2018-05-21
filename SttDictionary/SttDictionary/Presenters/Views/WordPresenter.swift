//
//  WordPresenter.swift
//  SttDictionary
//
//  Created by Admin on 5/16/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol WordDelegate: Viewable {
    func reloadWords()
}

class WordPresenter: SttPresenter<WordDelegate> {
    var words = [WordEntityCellPresenter]()
    
    var _wordService: IWordService!
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        
        _ = _wordService.observe.subscribe(onNext: { element in
            self.words.insert(element, at: 0)
            self.delegate.reloadWords()
        })
        
        _ = _wordService.getAllWord()
            .subscribe(onNext: { (elements) in
                self.words = elements
                self.delegate.reloadWords()
            })
    }
}
