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
    
    var words = SttObservableCollection<WordEntityCellPresenter>()
    var selectedWordsData = [(String, String)]()
    
    var _wordInteractor: WordInteractorType!

    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        
        search(seachString: nil)
    }
    
    var previusDispose: Disposable?
    func search(seachString: String?) {
        previusDispose?.dispose()
        self.words.removeAll()
        previusDispose = _wordInteractor.getWord(searchString: seachString, skip: 0)
            .subscribe(onNext: { (elements) in
                for item in elements {
                    item.itemDelegate = self
                }
                self.words.append(contentsOf: elements)
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
