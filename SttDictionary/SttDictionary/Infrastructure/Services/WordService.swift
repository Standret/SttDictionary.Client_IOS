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
    
    func getNewWord() -> Observable<[RealmWord]>
    func getRepeatWord() -> Observable<[RealmWord]>
    
    func updateStatistics(answer: Answer) -> Observable<Bool>
    
    var observe: Observable<WordEntityCellPresenter> { get }
}

class WordServie: IWordService {
    
    var _unitOfWork: IUnitOfWork!
    var _notificationError: INotificationError!
    var _smEngine: SMEngine!
    
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
                if let _ = predicatesModel?.newCard {
                    observables.append(getNewWord())
                }
                if let _ = predicatesModel?.repeatCard {
                    observables.append(getRepeatWord())
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
    
    func getNewWord() -> Observable<[RealmWord]> {
        let predicate = QueryFactories.getWordQuery(text: ":@today")
        return _notificationError.useError(observable:
            _unitOfWork.word.count(filter: NSPredicate(format: "any statistics.answers.date == %@", argumentArray: [Date().onlyDay()]).predicateFormat)
                .flatMap({ self._unitOfWork.word.getMany(filter: predicate?.newCard, take: Constants.countOfNewCard - $0) }))
    }
    
    func getRepeatWord() -> Observable<[RealmWord]> {
        let predicate = QueryFactories.getWordQuery(text: ":@today")
        return _notificationError.useError(observable: _unitOfWork.word.getMany(filter: predicate?.repeatCard))
    }
    func updateStatistics(answer: Answer) -> Observable<Bool> {
        return _notificationError.useError(observable: _unitOfWork.word.getOne(filter: "id = '\(answer.id)'")
            .flatMap { (word) -> Observable<Bool> in
                                
                return self._unitOfWork.word.update(update: { (rword) in
                    rword.isSynced = false
                    rword.statistics = self._smEngine.gradeFlashcard(statistics: word.statistics ?? RealmStatistics(), answer: answer)
                }, filter: "id = '\(answer.id)'")
                .toObservable()
        })
    }
}
