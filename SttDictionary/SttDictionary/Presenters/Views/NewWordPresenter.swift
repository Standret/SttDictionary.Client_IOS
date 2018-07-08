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
    
    var _wordInteractor: WordInteractorType!
    
    var save: SttComand!
    
    var word: String? {
        didSet {
            if !(word ?? "").trimmingCharacters(in: .whitespaces).isEmpty {
                _ = _wordInteractor.exists(word: word!.trimmingCharacters(in: .whitespaces))
                        .subscribe(onNext: { self.delegate?.error(isHidden: !$0) })
            }
        }
    }
    
    var mainTranslation = ShortWordsData()
    var linkedWords = ShortWordsData()
    var tags = ShortWordsData()
    
    var exampleOriginal: String?
    var exampleTranslate: String?
    
    var useReverse: Bool = true
    var usePronunciation: Bool = true
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        
        save = SttComand(delegate: self, handler: { $0.onSave() })
    }
    
    // api for view
    
    func addNewMainTranslation(value: String) {
        mainTranslation.data.append(WorldCollectionCellPresenter(value: value, delegate: mainTranslation))
    }
    func addNewLinkedWords(words:[(String, String)]) {
        linkedWords.data.append(contentsOf: sinq(words)
            .takeWhile({ data in !self.linkedWords.data.contains(where: { $0.id == data.0 })})
            .map({ WorldCollectionCellPresenter(value: $0.1, id: $0.0, delegate: linkedWords) }))
    }
    
    // comand handler
    
    func onSave() {
        var exampleUsage: ExampleUsage?
        if !(exampleOriginal ?? "").trimmingCharacters(in: .whitespaces).isEmpty && !(exampleTranslate ?? "").trimmingCharacters(in: .whitespaces).isEmpty {
            exampleUsage = ExampleUsage(original: exampleOriginal!, translate: exampleTranslate!)
        }
        if !(word ?? "").trimmingCharacters(in: .whitespaces).isEmpty && mainTranslation.data.count > 0 {
            _ = save.useWork(observable: _wordInteractor.addWord(word: word!.trimmingCharacters(in: .whitespaces),
                                                                 translations: mainTranslation.data.map( { $0.word!.trimmingCharacters(in: .whitespaces) } ),
                                                                 exampleUsage: exampleUsage,
                                                                 linkedWords: linkedWords.data.map( { $0.id! } ),
                                                                 tagsId: tags.data.map( { $0.word! } ),
                                                                 useReverse: useReverse,
                                                                 usePronunciation: usePronunciation))
                .subscribe(onNext: { (result) in
                    if result.0 && result.1 == .local {
                        print("save to lacal has been successfully")
                    }
                    else {
                        print("save to server has been successfully")
                    }
                })
        }
        else {
            delegate?.sendMessage(title: "Need field is empty", message: "Original word and main translation")
        }
    }
}
