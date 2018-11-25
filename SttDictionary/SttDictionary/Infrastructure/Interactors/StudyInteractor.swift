//
//  StudyInteractor.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/7/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift
import SINQ

protocol StudyInteractorType {
    func getStudyData() -> Observable<StudyWordsModel>
}

class StudyInteractor: StudyInteractorType {
    
    var _wordRepositories: WordRepositoriesType!
    var _statisticsRepositories: StatisticsRepositoriesType!
    var _answersRepositories: AnswerRepositoriesType!
    
    var _notificationError: NotificationErrorType!
    
    init() {
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    func getStudyData() -> Observable<StudyWordsModel> {
        let sequence = [
            getNewOriginal().map({ LocalWordsResult(type: .newOriginal, words: $0) }),
            getNewTranslate().map({ LocalWordsResult(type: .newTranslation, words: $0) }),
            getRepeatOriginal().map({ LocalWordsResult(type: .repeatOriginal, words: $0) }),
            getRepeatTranslation().map({ LocalWordsResult(type: .repeatTranslation, words: $0) })
            ]
        return Observable.zip(sequence, { (results) -> StudyWordsModel in
            
            return StudyWordsModel(newOriginal: results.first(where: { $0.type == .newOriginal })!.words,
                                   newTranslate: results.first(where: { $0.type == .newTranslation })!.words,
                                   repeatOriginal: results.first(where: { $0.type == .repeatOriginal })!.words,
                                   repeatTranslation: results.first(where: { $0.type == .repeatTranslation })!.words)
        })
        .inBackground()
        .observeInUI()
    }
    
    private func getNewOriginal() -> Observable<[WordApiModel]> {
        let elements = _statisticsRepositories.getNewOriginal()
            .flatMap({ self._wordRepositories.getWords(statistics: $0) })
            .trimLinkedWordsFrom(todayTrainedWords: todayAlreadyTrained())
            .trimLinkedWordsFrom(todayTrainedWords: unTrimmedRepeatOriginalWord())
            .trimLinkedWordsFrom(todayTrainedWords: unTrimmedRepeatTranslationWord())
            .trimLinkedWords()
            .trimSameIdWords(todayTrainedWords: todayAlreadyTrained(filter: [.translateCard]))
        
        return Observable.zip(elements, todayNewAlreadyTrained(filter: [.originalCard]),
                              resultSelector: { (elements, todayAlreadyTrained) -> [WordApiModel] in
                                return sinq(elements).take(Constants.countOfNewCard - todayAlreadyTrained.count).toArray()
        })
    }
    
    private func getNewTranslate() -> Observable<[WordApiModel]> {
        let elements = _statisticsRepositories.getNewTranslate()
            .flatMap({ self._wordRepositories.getWords(statistics: $0) })
            .map({ sinq($0).whereTrue({ $0.reverseCards }).toArray() })
            .trimLinkedWordsFrom(todayTrainedWords: todayAlreadyTrained())
            .trimLinkedWordsFrom(todayTrainedWords: unTrimmedRepeatOriginalWord())
            .trimLinkedWordsFrom(todayTrainedWords: unTrimmedRepeatTranslationWord())
            .trimLinkedWordsFrom(todayTrainedWords: unTrimmedNewOriginalWord())
            .trimLinkedWords()
            .trimSameIdWords(todayTrainedWords: todayAlreadyTrained(filter: [.originalCard]))
            .trimSameIdWords(todayTrainedWords: getNewOriginal())
        
        return Observable.zip(elements, todayNewAlreadyTrained(filter: [.translateCard]),
                              resultSelector: { (elements, todayAlreadyTrained) -> [WordApiModel] in
            return sinq(elements).take(Constants.countOfNewCard - todayAlreadyTrained.count).toArray()
        })
    }
    
    private func getRepeatOriginal() -> Observable<[WordApiModel]> {
        return _statisticsRepositories.getRepeatOriginal()
            .flatMap({ self._wordRepositories.getWords(statistics: $0) })
            .trimLinkedWordsFrom(todayTrainedWords: todayAlreadyTrained())
            .trimLinkedWords()
            .trimSameIdWords(todayTrainedWords: todayAlreadyTrained(filter: [.translateCard]))
            .trimSameIdWords(todayTrainedWords: getRepeatTranslation())
    }
    
    private func getRepeatTranslation() -> Observable<[WordApiModel]> {
        return _statisticsRepositories.getRepeatTranslate()
            .flatMap({ self._wordRepositories.getWords(statistics: $0) })
            .map({ sinq($0).whereTrue({ $0.reverseCards }).toArray() })
            .trimLinkedWordsFrom(todayTrainedWords: todayAlreadyTrained())
            .trimLinkedWordsFrom(todayTrainedWords: unTrimmedRepeatOriginalWord())
            .trimLinkedWords()
            .trimSameIdWords(todayTrainedWords: todayAlreadyTrained(filter: [.originalCard]))
    }
    
    private func todayNewAlreadyTrained(filter: [AnswersType] = [.originalCard, .translateCard]) -> Observable<[WordApiModel]> {
        var twords: [WordApiModel]!
        print(filter)
        return todayAlreadyTrained(filter: filter)
            .map({ twords = $0; return $0.map({ $0.id! }) })
            .flatMap({ self._answersRepositories.getAnswers(wordIds: $0) })
            .map({ sinq($0).whereTrue({ st in filter.contains(st.type) }).toArray() })
            .map { (answers) -> [WordApiModel] in
                var target = [WordApiModel]()
                for item in twords {
                    if sinq(answers).whereTrue({ $0.wordId == item.id }).all({ $0.dateCreated.onlyDay() == Date().onlyDay() }) {
                        target.append(item)
                    }
                }
                return target
            }
    }
    
    private func todayAlreadyTrained(filter: [AnswersType] = [.originalCard, .translateCard]) -> Observable<[WordApiModel]> {
        return _answersRepositories.getTodayAnswers()
            .map({ sinq($0).whereTrue({ st in filter.contains(st.type) }).toArray() })
            .flatMap({ self._wordRepositories.getWords(answers: $0) })
    }
    private func unTrimmedNewOriginalWord() -> Observable<[WordApiModel]> {
        return _statisticsRepositories.getNewOriginal()
            .flatMap({ self._wordRepositories.getWords(statistics: $0) })
    }
    private func unTrimmedRepeatOriginalWord() -> Observable<[WordApiModel]> {
        return _statisticsRepositories.getRepeatOriginal()
            .flatMap({ self._wordRepositories.getWords(statistics: $0) })
    }
    private func unTrimmedRepeatTranslationWord() -> Observable<[WordApiModel]> {
        return _statisticsRepositories.getRepeatTranslate()
            .flatMap({ self._wordRepositories.getWords(statistics: $0) })
    }
}
