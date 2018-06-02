//
//  WordPresenter.swift
//  SttDictionary
//
//  Created by Admin on 5/16/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

protocol WordDelegate: Viewable {
    func reloadWords()
}

final class CompletableResult {
    class func empty(inBackground: Bool = true) -> Completable {
        return Completable.empty()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
    }
    class func error(error: Error, inBackground: Bool = true) -> Completable {
        return Completable.error(error)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
    }
    class func never(inBackground: Bool = true) -> Completable {
        return Completable.never()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
    }
}

class WordPresenter: SttPresenter<WordDelegate> {
    var words = [WordEntityCellPresenter]()
    
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
        
        _ = _wordService.getAllWord()
            .subscribe(onNext: { (elements) in
                self.words = elements
                self.delegate.reloadWords()
            })
    }
}
