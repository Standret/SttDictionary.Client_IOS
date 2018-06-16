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

extension ObservableType
where E == [RealmWord] {
    
    func trimLinkedWords(key: String) -> Observable<E> {
        return self.map({ (targetWords) -> [RealmWord] in
            
            var targetResult = [RealmWord]()
            print ("\ntrim \(key)")
            print(targetWords.map({ $0.originalWorld }))

            // delete from target list (get first word and other linked delete)
            for item in targetWords {
                print (item.originalWorld)
                if !sinq(item.linkedWords).any({ lid in sinq(targetResult).any({ $0.id == lid.value }) }) {
                    targetResult.append(item)
                }
            }
            print(targetResult.map({ $0.originalWorld }))

            return targetResult
        })
    }
    
    func trimLinkedWordsFrom(todayTrainedWords: Observable<[RealmWord]>, key: String) -> Observable<E> {
        return Observable.zip(self, todayTrainedWords, resultSelector: { (targetWords, todayTrained) -> [RealmWord] in
            
            print ("\ntrim from \(key)")
            print(targetWords.map({ $0.originalWorld }))
            print(todayTrained.map({ $0.originalWorld }))
            // delete all linked words which trained today
            var targetResult = targetWords
            
            for item in todayTrained {
                for id in item.linkedWords {
                    if let _indexForDelete = targetResult.index(where: { $0.id == id.value }) {
                        targetResult.remove(at: _indexForDelete)
                    }
                }
            }
  
            print(targetResult.map({ $0.originalWorld }))
            return targetResult
        })
    }
    
    private func deleteLinkedWords(from: [RealmWord], with: [RealmWord]) -> [RealmWord] {
        
        var targetResult = from
        
        for item in with {
            for id in item.linkedWords {
                if let _indexForDelete = targetResult.index(where: { $0.id == id.value }) {
                    targetResult.remove(at: _indexForDelete)
                }
            }
        }
        
        return targetResult
    }
}

protocol IWordService {
    func getWord(searchString: String?) -> Observable<[WordEntityCellPresenter]>
    func createWord(word: String, translations: [String], linkedWords: [String]) -> Observable<Bool>
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
    
    func createWord(word: String, translations: [String], linkedWords: [String]) -> Observable<Bool> {
        return _notificationError.useError(observable: _unitOfWork.word.saveOne(model: WordFactories.createWordModel(word: word, translations: translations, linkedWords: linkedWords)).toEmptyObservable(ofType: Bool.self))
    }
    
    func exists(word: String) -> Observable<Bool> {
        return _notificationError.useError(observable: _unitOfWork.word.exists(filter: "originalWorld = '\(word)'"))
    }
    
    func getNewWord() -> Observable<[RealmWord]> {
        let predicate = QueryFactories.getWordQuery(text: ":@today")
        return _notificationError.useError(observable:
            _unitOfWork.word.getMany(filter: NSPredicate(format: "any originalStatistics.answers.date == %@", argumentArray: [Date().onlyDay()]).predicateFormat)
                .map({ sinq($0).whereTrue({ $0.originalStatistics!.answers.first!.date == Date().onlyDay() }).count() })
                .flatMap({ count in
                    self._unitOfWork.word.getMany(filter: predicate?.newOriginalCard)
                        .trimLinkedWordsFrom(todayTrainedWords: self.todayAlreadyTrained(), key: "getNewWord from already Trained")
                        .trimLinkedWordsFrom(todayTrainedWords: self.unTrimmedRepeatWord(), key: "getNewWord from already Repeat")
                        .trimLinkedWordsFrom(todayTrainedWords: self.unTrimmedRepeatTranslation(), key: "getNewWord from already RepeatTrans")
                        .trimLinkedWords(key: "getNewWord")
                        .map({ Array($0.prefix(Constants.countOfNewCard - count)) })
                })
        )
    }
    func getRepeatWord() -> Observable<[RealmWord]> {
        let predicate = QueryFactories.getWordQuery(text: ":@today")
        return _notificationError.useError(observable: _unitOfWork.word.getMany(filter: predicate?.repeatOriginalCard)
                                                        .trimLinkedWordsFrom(todayTrainedWords: todayAlreadyTrained(), key: "getRepeatWord from todayAlreadyTrained")
            .trimLinkedWords(key: "getRepeatWord"))
    }
    func getNewTranslationWord() -> Observable<[RealmWord]> {
        let predicate = QueryFactories.getWordQuery(text: ":@today")
        return _notificationError.useError(observable:
            _unitOfWork.word.getMany(filter: NSPredicate(format: "any translateStatistics.answers.date == %@", argumentArray: [Date().onlyDay()]).predicateFormat)
            .map({ sinq($0).whereTrue({ $0.translateStatistics!.answers.first!.date == Date().onlyDay() }).count() })
            .flatMap({ count in
                self._unitOfWork.word.getMany(filter: predicate?.newTranslationCard)
                    .trimLinkedWordsFrom(todayTrainedWords: self.todayAlreadyTrained(), key: "getNewTranslationWord from todayAlreadyTrained")
                    .trimLinkedWordsFrom(todayTrainedWords: self.unTrimmedRepeatWord(), key: "getNewTranslationWord from unTrimmedRepeatWord")
                    .trimLinkedWordsFrom(todayTrainedWords: self.unTrimmedRepeatTranslation(), key: "getNewTranslationWord from unTrimmedRepeatTranslation")
                    .trimLinkedWordsFrom(todayTrainedWords: self.unTrimmedNewWord(), key: "getNewTranslationWord from unTrimmedNewWord")
                    .trimLinkedWords(key: "getNewTranslationWord")
                    .map({ Array($0.prefix(Constants.countOfNewCard - count)) })
            })
        )
    }
    func getRepeatTranslationWord() -> Observable<[RealmWord]> {
        let predicate = QueryFactories.getWordQuery(text: ":@today")
        return _notificationError.useError(observable: _unitOfWork.word.getMany(filter: predicate?.repeatTranslationCard)
                                                        .trimLinkedWordsFrom(todayTrainedWords: todayAlreadyTrained(), key: "getRepeatTranslationWord from todayAlreadyTrained")
                                                        .trimLinkedWordsFrom(todayTrainedWords: unTrimmedRepeatWord(), key: "getRepeatTranslationWord from unTrimmedRepeatWord")
                                                        .trimLinkedWords(key: "getRepeatTranslationWord"))
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
    
    private func unTrimmedRepeatWord() -> Observable<[RealmWord]> {
        let predicate = QueryFactories.getWordQuery(text: ":@today")
        return _unitOfWork.word.getMany(filter: predicate?.repeatOriginalCard)
    }
    private func unTrimmedRepeatTranslation() -> Observable<[RealmWord]> {
        let predicate = QueryFactories.getWordQuery(text: ":@today")
        return _unitOfWork.word.getMany(filter: predicate?.repeatTranslationCard)
    }
    private func unTrimmedNewWord() -> Observable<[RealmWord]> {
        let predicate = QueryFactories.getWordQuery(text: ":@today")
        return _unitOfWork.word.getMany(filter: predicate?.newOriginalCard)
    }
    private func todayAlreadyTrained() -> Observable<[RealmWord]> {
        let predicate = NSPredicate(format: "(any translateStatistics.answers.date == %@ or any originalStatistics.answers.date == %@) and linkedWords.@count > 0", argumentArray: [Date().onlyDay(), Date().onlyDay()])
        return _unitOfWork.word.getMany(filter: predicate.predicateFormat)
    }
}
