//
//  NewWordPresenter.swift
//  SttDictionary
//
//  Created by Admin on 5/16/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift
import SINQ

protocol NewWordDelegate: SttViewContolable {
    func error(isHidden: Bool)
}

class ShortWordsData: ShortWordItemDelegate {
    
    var data = SttObservableCollection<WorldCollectionCellPresenter>()

    func deleteItem(word: String?) {
        if let index = data.index(where: { $0.word == word }) {
            data.remove(at: index)
        }
    }
}

class NewWordPresenter: SttPresenter<NewWordDelegate> {
    
    var word: String? {
        didSet {
            if !(word ?? "").trimmingCharacters(in: .whitespaces).isEmpty {
                _ = _wordService.exists(word: word!).subscribe(onNext: { self.delegate?.error(isHidden: !$0) })
            }
        }
    }
    var mainTranslation = ShortWordsData()
    var linkedWords = ShortWordsData()
    var save: SttComand!
    var useReverse: Bool = true
    
    var _wordService: IWordService!
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        
        save = SttComand(delegate: self, handler: { $0.onSave() })
    }
    
    func addNewMainTranslation(value: String) {
        mainTranslation.data.append(WorldCollectionCellPresenter(value: value, delegate: mainTranslation))
    }
    func addNewLinkedWords(words:[(String, String)]) {
        linkedWords.data.append(contentsOf: sinq(words)
            .takeWhile({ data in !self.linkedWords.data.contains(where: { $0.id == data.0 })})
            .map({ WorldCollectionCellPresenter(value: $0.1, id: $0.0, delegate: linkedWords) }))
    }
    
    func onSave() {
        if !(word ?? "").trimmingCharacters(in: .whitespaces).isEmpty && mainTranslation.data.count > 0 {
            _ = save.useWork(observable: _wordService.createWord(word: word!, translations: mainTranslation.data.map( { $0.word! } ), linkedWords: linkedWords.data.map({ $0.id! }), useReverse: useReverse))
            .subscribe(onNext: { (result) in
                print("successfule saved")
            })
        }
    }
}
