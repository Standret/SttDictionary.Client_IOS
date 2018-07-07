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
where E == [WordApiModel] {
    
    func trimSameIdWords(todayTrainedWords: Observable<[WordApiModel]>, key: String = "") -> Observable<E> {
        return Observable.zip(self, todayTrainedWords, resultSelector: { (targetWords, todayTrained) -> [WordApiModel] in
            
           // print ("\ntrimSameIdWords \(key)")
           // print(targetWords.map({ $0.originalWorld }))
           // print(todayTrained.map({ $0.originalWorld }))
            // delete all linked words which trained today
            var targetResult = targetWords
            
            for item in todayTrained {
                if let index = targetResult.index(where: { $0.id == item.id }) {
                    targetResult.remove(at: index)
                }
            }
            
           // print(targetResult.map({ $0.originalWorld }))
            return targetResult
        })
    }
    
    func trimLinkedWords(key: String = "") -> Observable<E> {
        return self.map({ (targetWords) -> [WordApiModel] in
            
            var targetResult = [WordApiModel]()
           // print ("\ntrim \(key)")
           // print(targetWords.map({ $0.originalWorld }))

            // delete from target list (get first word and other linked delete)
            for item in targetWords {
                if !sinq(item.linkedWords ?? []).any({ lid in sinq(targetResult).any({ $0.id == lid }) }) {
                    targetResult.append(item)
                }
            }
          //  print(targetResult.map({ $0.originalWorld }))

            return targetResult
        })
    }
    
    func trimLinkedWordsFrom(todayTrainedWords: Observable<[WordApiModel]>, key: String = "") -> Observable<E> {
        return Observable.zip(self, todayTrainedWords, resultSelector: { (targetWords, todayTrained) -> [WordApiModel] in
            
            print ("\ntrim from \(key)")
          //  print(targetWords.map({ $0.originalWorld }))
          //  print(todayTrained.map({ $0.originalWorld }))
            // delete all linked words which trained today
            var targetResult = targetWords
            
            for item in todayTrained {
                for id in (item.linkedWords ?? []) {
                    if let _indexForDelete = targetResult.index(where: { $0.id == id }) {
                        targetResult.remove(at: _indexForDelete)
                    }
                }
            }
  
           // print(targetResult.map({ $0.originalWorld }))
            return targetResult
        })
    }
    
    private func deleteLinkedWords(from: [WordApiModel], with: [WordApiModel]) -> [WordApiModel] {
        
        var targetResult = from
        
        for item in with {
            for id in (item.linkedWords ?? []) {
                if let _indexForDelete = targetResult.index(where: { $0.id == id }) {
                    targetResult.remove(at: _indexForDelete)
                }
            }
        }
        
        return targetResult
    }
}

protocol IWordService {
    func getWord(searchString: String?) -> Observable<[WordEntityCellPresenter]>
    func createWord(word: String, translations: [String], linkedWords: [String], useReverse: Bool) -> Observable<Bool>
    func exists(word: String) -> Observable<Bool>
    
    func getNewWord() -> Observable<[RealmWord]>
    func getRepeatWord() -> Observable<[RealmWord]>
    func getNewTranslationWord() -> Observable<[RealmWord]>
    func getRepeatTranslationWord() -> Observable<[RealmWord]>
    
    func updateStatistics(answer: Answer, type: AnswersType) -> Observable<Bool>
    
    var observe: Observable<(WordEntityCellPresenter, RealmStatus)> { get }
}

class WordServie: IWordService {
    
    var _unitOfWork: RealmStorageProviderType!
    var _notificationError: NotificationErrorType!
    var _smEngine: SMEngine!
    
    var observe: Observable<(WordEntityCellPresenter, RealmStatus)> { return _notificationError.useError(observable: _unitOfWork.word.observe(on: [RealmStatus.Inserted, RealmStatus.Updated]).map( { (WordEntityCellPresenter(fromObject: $0.0), $0.1) } )) }
    
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
    
    func createWord(word: String, translations: [String], linkedWords: [String], useReverse: Bool) -> Observable<Bool> {
        return _notificationError.useError(observable: _unitOfWork.word.saveOne(model: WordFactories.createWordModel(word: word, translations: translations, linkedWords: linkedWords, useReverse: useReverse)).toEmptyObservable(ofType: Bool.self))
    }
    
    func exists(word: String) -> Observable<Bool> {
        return _notificationError.useError(observable: _unitOfWork.word.exists(filter: "originalWorld = '\(word)'"))
    }
    
    func getNewWord() -> Observable<[RealmWord]> {
        return Observable<[RealmWord]>.empty()
//        let predicate = QueryFactories.getWordQuery(text: ":@today")
//        return _notificationError.useError(observable:
//            _unitOfWork.word.getMany(filter: NSPredicate(format: "any originalStatistics.answers.date == %@", argumentArray: [Date().onlyDay()]).predicateFormat)
//                .map({ let ii = sinq($0).whereTrue({ $0.originalStatistics!.answers.first!.date == Date().onlyDay() }).count()
//                    print("new: \(ii)")
//                    print(sinq($0).whereTrue({ $0.originalStatistics!.answers.first!.date == Date().onlyDay() }).map({ $0.originalWorld }).toArray())
//                    return ii
//                })
//                .flatMap({ count in
//                    self._unitOfWork.word.getMany(filter: predicate?.newOriginalCard)
//                        .trimLinkedWordsFrom(todayTrainedWords: self.todayAlreadyTrained(), key: "getNewWord from already Trained")
//                        .trimLinkedWordsFrom(todayTrainedWords: self.unTrimmedRepeatWord(), key: "getNewWord from already Repeat")
//                        .trimLinkedWordsFrom(todayTrainedWords: self.unTrimmedRepeatTranslation(), key: "getNewWord from already RepeatTrans")
//                        .trimLinkedWords(key: "getNewWord")
//                        .trimSameIdWords(todayTrainedWords: self.todayTranslateTrained(), key: "getNewWord")
//                        .map({ Array($0.prefix(Constants.countOfNewCard - count)) })
//                })
//        )
    }
    func getRepeatWord() -> Observable<[RealmWord]> {
        fatalError()
//        let predicate = QueryFactories.getWordQuery(text: ":@today")
//        return _notificationError.useError(observable: _unitOfWork.word.getMany(filter: predicate?.repeatOriginalCard)
//            .trimLinkedWordsFrom(todayTrainedWords: todayAlreadyTrained(), key: "getRepeatWord from todayAlreadyTrained")
//            .trimLinkedWords(key: "getRepeatWord"))
//            .trimSameIdWords(todayTrainedWords: todayTranslateTrained(), key: "getRepeatWord")
    }
    func getNewTranslationWord() -> Observable<[RealmWord]> {
        return Observable<[RealmWord]>.empty()
//        let predicate = QueryFactories.getWordQuery(text: ":@today")
//        return _notificationError.useError(observable:
//            _unitOfWork.word.getMany(filter: NSPredicate(format: "any translateStatistics.answers.date == %@", argumentArray: [Date().onlyDay()]).predicateFormat)
//            .map({ let ii = sinq($0).whereTrue({ $0.translateStatistics!.answers.first!.date == Date().onlyDay() }).count()
//                print("newTrans: \(ii)")
//                print(sinq($0).whereTrue({ $0.translateStatistics!.answers.first!.date == Date().onlyDay() }).map({ $0.originalWorld }).toArray())
//                return ii
//            })
//            .flatMap({ count in
//                self._unitOfWork.word.getMany(filter: predicate?.newTranslationCard)
//                    .trimLinkedWordsFrom(todayTrainedWords: self.todayAlreadyTrained(), key: "getNewTranslationWord from todayAlreadyTrained")
//                    .trimLinkedWordsFrom(todayTrainedWords: self.unTrimmedRepeatWord(), key: "getNewTranslationWord from unTrimmedRepeatWord")
//                    .trimLinkedWordsFrom(todayTrainedWords: self.unTrimmedRepeatTranslation(), key: "getNewTranslationWord from unTrimmedRepeatTranslation")
//                    .trimLinkedWordsFrom(todayTrainedWords: self.unTrimmedNewWord(), key: "getNewTranslationWord from unTrimmedNewWord")
//                    .trimLinkedWords(key: "getNewTranslationWord")
//                    .trimSameIdWords(todayTrainedWords: self.todayOriginalTrained(), key: "getNewTranslationWord")
//                    .map({ Array($0.prefix(Constants.countOfNewCard - count)) })
//            })
//        )
    }
    func getRepeatTranslationWord() -> Observable<[RealmWord]> {
        fatalError()
//        let predicate = QueryFactories.getWordQuery(text: ":@today")
//        return _notificationError.useError(observable: _unitOfWork.word.getMany(filter: predicate?.repeatTranslationCard)
//            .trimLinkedWordsFrom(todayTrainedWords: todayAlreadyTrained(), key: "getRepeatTranslationWord from todayAlreadyTrained")
//            .trimLinkedWordsFrom(todayTrainedWords: unTrimmedRepeatWord(), key: "getRepeatTranslationWord from unTrimmedRepeatWord")
//            .trimLinkedWords(key: "getRepeatTranslationWord"))
//            .trimSameIdWords(todayTrainedWords: self.todayOriginalTrained(), key: "getRepeatTranslationWord")
    }
    
    func updateStatistics(answer: Answer, type: AnswersType) -> Observable<Bool> {
        return Observable<Bool>.empty()
//        return _notificationError.useError(observable: _unitOfWork.word.getOne(filter: "id = '\(answer.id)'")
//            .flatMap { (word) -> Observable<Bool> in
//
//                return self._unitOfWork.word.update(update: { (rword) in
//                    rword.isSynced = false
//                    if type == .originalCard {
//                        rword.originalStatistics = self._smEngine.gradeFlashcard(statistics: word.originalStatistics ?? RealmStatistics(), answer: answer)
//                    }
//                    else {
//                        rword.translateStatistics = self._smEngine.gradeFlashcard(statistics: word.translateStatistics ?? RealmStatistics(), answer: answer)
//                    }
//                }, filter: "id = '\(answer.id)'")
//                .toObservable()
//        })
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
    private func todayOriginalTrained() -> Observable<[RealmWord]> {
        let predicate = NSPredicate(format: "any originalStatistics.answers.date == %@", argumentArray: [Date().onlyDay()]).predicateFormat
        return _unitOfWork.word.getMany(filter: predicate)
    }
    private func todayTranslateTrained() -> Observable<[RealmWord]> {
        let predicate = NSPredicate(format: "any translateStatistics.answers.date == %@", argumentArray: [Date().onlyDay()]).predicateFormat
        return _unitOfWork.word.getMany(filter: predicate)
    }
}
