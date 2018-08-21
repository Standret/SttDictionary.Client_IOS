//
//  WordPresenter.swift
//  SttDictionary
//
//  Created by Admin on 5/16/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

protocol WordDelegate: SttViewControlable {
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
    var words = SttObservableCollection<WordEntityCellPresenter>()
    
    var _wordInteractor: WordInteractorType!
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        
        search(seachString: nil)
    }
    
    var previusDispose: Disposable?
    func search(seachString: String?) {
        previusDispose?.dispose()
        self.words.removeAll()
        previusDispose = _wordInteractor.getWord(searchString: seachString)
            .subscribe(onNext: { (elements) in
                self.words.append(contentsOf: elements)
            })
    }
}
