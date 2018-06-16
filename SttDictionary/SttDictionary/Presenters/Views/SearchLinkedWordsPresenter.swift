//
//  SearchLinkedWordsPresenter.swift
//  SttDictionary
//
//  Created by Standret on 15.06.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchLinkedWordsDelegate {
    func reloadWords()
}

class SearchLinkedWordsPresenter: SttPresenter<SearchLinkedWordsDelegate>, WordItemDelegate {
    
    var words = [WordEntityCellPresenter]()
    var selectedWordsData = [(String, String)]()
    
    var _wordService: IWordService!
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        
        _ = _wordService.observe.subscribe(onNext: { [weak self] element in
            if let _self = self {
                if let index = _self.words.index(where: { $0.word == element.word }) {
                    _self.words.remove(at: index)
                    _self.words.insert(element, at: index)
                }
                else {
                    _self.words.insert(element, at: 0)
                }
                _self.delegate.reloadWords()
            }
        })
        
        search(seachString: nil)
    }
    
    var previusDispose: Disposable?
    func search(seachString: String?) {
        previusDispose?.dispose()
        self.words = []
        previusDispose = _wordService.getWord(searchString: seachString)
            .subscribe(onNext: { (elements) in
                self.words.append(contentsOf: elements)
                for item in elements {
                    item.itemDelegate = self
                }
                self.delegate.reloadWords()
            })
    }
    
    func onClick(id: String, name: String) {
        if let index = selectedWordsData.index(where: { $0.0 == id }) {
            selectedWordsData.remove(at: index)
        }
        else {
            selectedWordsData.append((id, name))
        }
    }
}
