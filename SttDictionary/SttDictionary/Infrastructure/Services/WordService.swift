//
//  WordService.swift
//  SttDictionary
//
//  Created by Admin on 5/20/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

protocol IWordService {
    func getWord(searchString: String?) -> Observable<[WordEntityCellPresenter]>
    func createWord(word: String, translations: [String]) -> Observable<Bool>
    func exists(word: String) -> Observable<Bool>
    
    var observe: Observable<WordEntityCellPresenter> { get }
}

class WordServie: IWordService {
    
    var _unitOfWork: IUnitOfWork!
    var _notificationError: INotificationError!
    
    var observe: Observable<WordEntityCellPresenter> { return _notificationError.useError(observable: _unitOfWork.word.observe(on: [RealmStatus.Inserted]).map( { WordEntityCellPresenter(element: $0.0) } )) }
    
    init () {
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    func getWord(searchString: String?) -> Observable<[WordEntityCellPresenter]> {
        var observable = _unitOfWork.word.getMany()
        if let _searchStr = searchString {
            if QueryFactories.isRegisterSchem(scheme: _searchStr) {
                let predicatesModel = QueryFactories.getWordQuery(text: _searchStr)
                var observables = [Observable<[RealmWord]>]()
                if let newCard = predicatesModel?.newCard {
                    observables.append(_unitOfWork.word.getMany(filter: newCard, take: 15).do(onNext: { print($0.count) }))
                }
                if let repeatCard = predicatesModel?.repeatCard {
                    observables.append(_unitOfWork.word.getMany(filter: repeatCard, take: 15).do(onNext: { print($0.count) }))
                }
                observable = Observable.concat(observables)
            }
            else if !_searchStr.isEmpty {
                let query = "originalWorld contains[cd] '\(_searchStr)' or any translations.value contains[cd] '\(_searchStr)'"
                observable = _unitOfWork.word.getMany(filter: query)
            }
            else {
                observable = _unitOfWork.word.getMany()
            }
        }
        return _notificationError.useError(observable: observable.map( { $0.map( { WordEntityCellPresenter(fromObject: $0) } )}))
    }
    
    func createWord(word: String, translations: [String]) -> Observable<Bool> {
        return _notificationError.useError(observable: _unitOfWork.word.saveOne(model: WordFactories.createWordModel(word: word, translations: translations)).toEmptyObservable(ofType: Bool.self))
    }
    
    func exists(word: String) -> Observable<Bool> {
        return _notificationError.useError(observable: _unitOfWork.word.exists(filter: "originalWorld = '\(word)'"))
    }
}
