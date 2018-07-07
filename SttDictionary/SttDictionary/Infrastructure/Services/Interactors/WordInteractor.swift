//
//  WordInteractors.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/7/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

protocol WordInteractorType {
    func addWord(word: String, translations: [String], exampleUsage: ExampleUsage?,
                 linkedWords: [String]?, tagsId: [String]?, useReverse: Bool, usePronunciation: Bool) -> Observable<(Bool, SyncStep)>
    func exists(word: String) -> Observable<Bool>
}

extension WordInteractorType {
    func addWord(word: String, translations: [String], exampleUsage: ExampleUsage? = nil,
                 linkedWords: [String]? = nil, tagsId: [String]? = nil, useReverse: Bool = true, usePronunciation: Bool = true) -> Observable<(Bool, SyncStep)> {
        
        return self.addWord(word: word, translations: translations, exampleUsage: exampleUsage,
                            linkedWords: linkedWords, tagsId: tagsId, useReverse: useReverse, usePronunciation: usePronunciation)
    }
}

class WordInteractor: WordInteractorType {
    
    var _wordRepositories: WordRepositoriesType!
    var _notificationError: NotificationErrorType!
    
    init() {
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    func addWord(word: String, translations: [String], exampleUsage: ExampleUsage?,
                 linkedWords: [String]?, tagsId: [String]?, useReverse: Bool, usePronunciation: Bool) -> Observable<(Bool, SyncStep)> {
        
        return _notificationError.useError(observable: _wordRepositories.addWord(model: AddWordApiModel(word: word,
                                                                translations: translations,
                                                                pronunciationUrl: nil,
                                                                exampleUsage: exampleUsage,
                                                                tagsId: tagsId,
                                                                linkedWords: linkedWords,
                                                                reverseCards: useReverse,
                                                                usePronunciation: usePronunciation))
            .inBackground()
            .observeInUI())
    }
    
    func exists(word: String) -> Observable<Bool> {
        return _notificationError.useError(observable: _wordRepositories.exists(originalWord: word))
            .inBackground()
            .observeInUI()
    }
}
