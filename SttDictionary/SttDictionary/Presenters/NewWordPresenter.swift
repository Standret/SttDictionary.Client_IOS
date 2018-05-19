//
//  NewWordPresenter.swift
//  SttDictionary
//
//  Created by Admin on 5/16/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

protocol NewWordDelegate: Viewable {
    func reloadMainCollectionCell()
}

class NewWordPresenter: SttPresenter<NewWordDelegate>, WordItemDelegate {
    
    var mainTranslation = [WorldCollectionCellPresenter]()
    var save: RxComand!
    
    override func presenterCreating() {
        save = RxComand(handler: onSave)
    }
    
    func addNewMainTranslation(value: String) {
        mainTranslation.append(WorldCollectionCellPresenter(value: value, delegate: self))
        delegate.reloadMainCollectionCell()
    }
    
    func onSave() {
        let obs = Observable<Bool>.create({ (observer) -> Disposable in
            
            sleep(3)
            observer.onNext(true)
            observer.onNext(true)
            observer.onNext(true)
            observer.onNext(true)
            observer.onCompleted()
            
            return Disposables.create()
        })
        _ = save.useWork(observable: obs)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (res) in
            
            }, onCompleted: { })
        
    }
    
    func deleteItem(word: String?) {
        let _index = mainTranslation.index { (element) -> Bool in
            if element.word == word {
                return true
            }
            return false
        }
        
        if let index = _index {
            mainTranslation.remove(at: index)
            delegate.reloadMainCollectionCell()
        }
    }
}
