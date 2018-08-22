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
    var tags = SttObservableCollection<TagEntityCellPresenter>()
    
    var selectedData = [(String, String)]()
    
    var _wordInteractor: WordInteractorType!
    var _tagInteractor: TagInteractorType!
    
    var contentType: MainContentType!
    
    override func prepare(parametr: Any?) {
        let param = parametr as! Bool
        contentType = param ? MainContentType.words : MainContentType.tags
        search(seachString: "")
    }

    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    private var previusDispose: Disposable?
    private var previusSearchStr: String = ""
    
    func search(seachString: String) {
        
        previusDispose?.dispose()
        self.words.removeAll()
        
        switch contentType {
        case .words:
            previusDispose = getWords(searchString: seachString, skip: words.count)
        case .tags:
            previusDispose = getTags(searchString: seachString, skip: tags.count)
        default: break;
        }
    }
    
    private func getWords(searchString: String?, skip: Int) -> Disposable {
        return _wordInteractor.getWord(searchString: searchString, skip: words.count)
            .subscribe(onNext: { (elements) in
                for item in elements {
                    item.itemDelegate = self
                }
                self.words.append(contentsOf: elements)
            })
    }
    
    private func getTags(searchString: String?, skip: Int) -> Disposable {
        return _tagInteractor.get(searchStr: searchString, skip: tags.count)
            .subscribe(onNext: { (elements) in
                for item in elements {
                    item.itemDelegate = self
                }
                self.tags.append(contentsOf: elements)
            })
    }
    
    func onClick(id: String, name: String) {
        if let index = selectedData.index(where: { $0.0 == id }) {
            selectedData.remove(at: index)
        }
        else {
            selectedData.append((id, name))
        }
    }
}
