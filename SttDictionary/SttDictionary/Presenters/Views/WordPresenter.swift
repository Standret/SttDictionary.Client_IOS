//
//  WordPresenter.swift
//  SttDictionary
//
//  Created by Admin on 5/16/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

enum MainContentType {
    case words, tags, time
}

protocol WordDelegate: SttViewControlable { }

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
    var tags = SttObservableCollection<TagEntityCellPresenter>()
    
    var _wordInteractor: WordInteractorType!
    var _tagInteractor: TagInteractorType!
    var contentType: MainContentType = MainContentType.words {
        didSet {
            search(seachString: previusSearchStr)
        }
    }
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        
        search(seachString: "")
    }
    
    private var previusDispose: Disposable?
    private var previusSearchStr: String = ""
    
    func search(seachString: String) {
        if (seachString.trimmingCharacters(in: .whitespaces) != previusSearchStr) {
            previusDispose?.dispose()
            self.words.removeAll()
        }
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
                self.words.append(contentsOf: elements)
            })
    }
    
    private func getTags(searchString: String?, skip: Int) -> Disposable {
        return _tagInteractor.get(searchStr: searchString, skip: tags.count)
            .subscribe(onNext: { (elements) in
                self.tags.append(contentsOf: elements)
            })
    }
}
