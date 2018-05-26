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
        
        print ("start in \(Thread.current)")
        exampleFunc(res: true).asObservable().flatMap({ _ in Observable<Bool>.empty() })
            .subscribe(onNext: { (res) in
                print("onnext \(res)")
            }, onCompleted: {
                print("onCompleted")
            })
        
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
        return Completable.create { (observer) -> Disposable in
            if res {
                print ("do in \(Thread.current)")
                sleep(5)
                observer(CompletableEvent.completed)
                observer(CompletableEvent.completed)
                observer(CompletableEvent.completed)
                observer(CompletableEvent.completed)
                //.observeOn(MainScheduler.instance)
            }
            else {
                Completable.never()
                Completable.never()
                //return Completable.empty()
                Completable.never()
                Completable.never()
                Completable.never()
            }
            
            return Disposables.create()
        }.inBackground().observeInUI()
        //.observeInCurrent()
        
    }
}
