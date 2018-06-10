//
//  WordService.swift
//  SttDictionary
//
//  Created by Admin on 5/20/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift
import SINQ

protocol IWordService {
    func getWord(searchString: String?) -> Observable<[WordEntityCellPresenter]>
    func createWord(word: String, translations: [String]) -> Observable<Bool>
    func exists(word: String) -> Observable<Bool>
    
    func getNewWord() -> Observable<[RealmWord]>
    func getRepeatWord() -> Observable<[RealmWord]>
    func getNewTranslationWord() -> Observable<[RealmWord]>
    func getRepeatTranslationWord() -> Observable<[RealmWord]>
    
    func updateStatistics(answer: Answer, type: AnswersType) -> Observable<Bool>
    
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
                if predicatesModel?.newOriginalCard != nil {
                    observables.append(getNewWord())
                }
                if predicatesModel?.newTranslationCard != nil {
                    observables.append(getRepeatWord())
                }
                if predicatesModel?.newTranslationCard != nil {
                    observables.append(getNewTranslationWord())
                }
                if predicatesModel?.repeatTranslationCard != nil {
                    observables.append(getRepeatTranslationWord())
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
            _unitOfWork.word.getMany(filter: NSPredicate(format: "any originalStatistics.answers.date == %@", argumentArray: [Date().onlyDay()]).predicateFormat)
                .map({ sinq($0).whereTrue({ $0.originalStatistics!.answers.first!.date == Date().onlyDay() }).count() })
                .flatMap({ self._unitOfWork.word.getMany(filter: predicate?.newOriginalCard, take: Constants.countOfNewCard - $0) }))
    }
    func getRepeatWord() -> Observable<[RealmWord]> {
        let predicate = QueryFactories.getWordQuery(text: ":@today")
        return _notificationError.useError(observable: _unitOfWork.word.getMany(filter: predicate?.repeatOriginalCard))
    }
    func getNewTranslationWord() -> Observable<[RealmWord]> {
        let predicate = QueryFactories.getWordQuery(text: ":@today")
        return _notificationError.useError(observable:
            _unitOfWork.word.getMany(filter: NSPredicate(format: "any translateStatistics.answers.date == %@", argumentArray: [Date().onlyDay()]).predicateFormat)
                .map({ sinq($0).whereTrue({ $0.translateStatistics!.answers.first!.date == Date().onlyDay() }).count() })
                .flatMap({ self._unitOfWork.word.getMany(filter: predicate?.newTranslationCard, take: Constants.countOfNewCard - $0) }))
    }
    func getRepeatTranslationWord() -> Observable<[RealmWord]> {
        let predicate = QueryFactories.getWordQuery(text: ":@today")
        return _notificationError.useError(observable: _unitOfWork.word.getMany(filter: predicate?.repeatTranslationCard))
    }
    
    func updateStatistics(answer: Answer, type: AnswersType) -> Observable<Bool> {
        return _notificationError.useError(observable: _unitOfWork.word.getOne(filter: "id = '\(answer.id)'")
            .flatMap { (word) -> Observable<Bool> in
                                
                return self._unitOfWork.word.update(update: { (rword) in
                    rword.isSynced = false
                    if type == .originalCard {
                        rword.originalStatistics = self._smEngine.gradeFlashcard(statistics: word.originalStatistics ?? RealmStatistics(), answer: answer)
                    }
                    else {
                        rword.translateStatistics = self._smEngine.gradeFlashcard(statistics: word.translateStatistics ?? RealmStatistics(), answer: answer)
                    }
                }, filter: "id = '\(answer.id)'")
                .toObservable()
        })
    }
}
