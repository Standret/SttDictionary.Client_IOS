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

class WordPresenter: SttPresenter<WordDelegate> {
    var words = [WordEntityCellPresenter]()
    
    var _wordService: IWordService!
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        
        exampleFunc(res: false)
            .subscribe(onCompleted: {
                print("completed")
            }) { (error) in
                print("error")
        }
        
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
    
    func exampleFunc(res: Bool) -> Completable {
        if res {
            return Completable.error(BaseError.unkown("some rr"))
            return Completable.empty()
            return Completable.empty()
            Completable.never()
            return Completable.empty()
        }
        else {
            Completable.never()
            Completable.never()
            return Completable.empty()
            Completable.never()
            Completable.never()
            Completable.never()
        }
    }
}
