//
//  WordInteractors.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/7/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift
import SINQ

struct IntervalsModel {
    
    let easy: Int
    let hard: Int
    let badHard: Int
    let forget: Int
}

protocol WordInteractorType {
    func addWord(word: String, translations: [String], exampleUsage: ExampleUsage?,
                 linkedWords: [String]?, tagsId: [String]?, useReverse: Bool, usePronunciation: Bool, explanation: String?) -> Observable<(Bool, SyncStep)>
    func exists(word: String) -> Observable<Bool>
    func getWord(searchString: String?, skip: Int) -> Observable<[WordEntityCellPresenter]>
    
    func getIntervals(wordId: String, type: AnswersType) -> Observable<IntervalsModel>
    func updateStatistics(answer: Answer, type: AnswersType) -> Observable<Bool>
}

extension WordInteractorType {
    func addWord(word: String, translations: [String], exampleUsage: ExampleUsage? = nil,
                 linkedWords: [String]? = nil, tagsId: [String]? = nil, useReverse: Bool = true, usePronunciation: Bool = true) -> Observable<(Bool, SyncStep)> {
        
        return self.addWord(word: word, translations: translations, exampleUsage: exampleUsage,
                            linkedWords: linkedWords, tagsId: tagsId, useReverse: useReverse, usePronunciation: usePronunciation)
    }
}

class WordInteractor: WordInteractorType {
    
    var _wordRepositories: WordRepositoriesType!
    var _statisticsRepositories: StatisticsRepositoriesType!
    var _answerRepositories: AnswerRepositoriesType!
    var _notificationError: NotificationErrorType!
    var _smEngine: SMEngine!
    
    init() {
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    func addWord(word: String, translations: [String], exampleUsage: ExampleUsage?,
                 linkedWords: [String]?, tagsId: [String]?, useReverse: Bool, usePronunciation: Bool, explanation: String?) -> Observable<(Bool, SyncStep)> {
        
        return _notificationError.useError(observable: _wordRepositories.addWord(model: AddWordApiModel(word: word,
                                                                translations: translations,
                                                                pronunciationUrl: nil,
                                                                exampleUsage: exampleUsage,
                                                                tagsId: tagsId,
                                                                linkedWords: linkedWords,
                                                                reverseCards: useReverse,
                                                                usePronunciation: usePronunciation,
                                                                explanation: explanation))
            .inBackground()
            .observeInUI())
    }
    
    func exists(word: String) -> Observable<Bool> {
        return _notificationError.useError(observable: _wordRepositories.exists(originalWord: word))
            .inBackground()
            .observeInUI()
    }
    
    func getWord(searchString: String?, skip: Int) -> Observable<[WordEntityCellPresenter]> {
        var twords: [WordApiModel]!
        return _notificationError.useError(observable: _wordRepositories.get(searchStr: searchString, skip: skip, take: 50)
            .map({ twords = $0; return $0.map({ $0.id }) })
            .flatMap({ self._statisticsRepositories.getElementFor(wordsId: $0) })
            .map { (statistics) -> [WordEntityCellPresenter] in
                var result = [WordEntityCellPresenter]()
                for item in twords {
                    let cword = WordEntityCellPresenter(element: item)
                    cword.nextOriginalDate = sinq(statistics).whereTrue({ $0.wordId == item.id && $0.type == .originalCard }).firstOrNil()?.nextRepetition
                    cword.nextTranslationDate = sinq(statistics).whereTrue({ $0.wordId == item.id && $0.type == .translateCard }).firstOrNil()?.nextRepetition
                    result.append(cword)
                }
                
                return result
            }
            .map({ (words) -> [WordEntityCellPresenter] in
                var tempory = words
                if (searchString == ":@asc-o") {
                    tempory.sort(by: { ($0.nextOriginalDate ?? Date()) > ($1.nextOriginalDate ?? Date()) })
                }
                else if searchString == ":@desc-o" {
                    tempory.sort(by: { ($0.nextOriginalDate ?? Date()) < ($1.nextOriginalDate ?? Date()) })
                }
                else if (searchString == ":@asc-t") {
                    tempory.sort(by: { ($0.nextTranslationDate ?? Date()) > ($1.nextTranslationDate ?? Date()) })
                }
                else if searchString == ":@desc-t" {
                    tempory.sort(by: { ($0.nextTranslationDate ?? Date()) < ($1.nextTranslationDate ?? Date()) })
                }
                return tempory
            })
            .inBackground()
            .observeInUI())
    }
    
    func getIntervals(wordId: String, type: AnswersType) -> Observable<IntervalsModel> {
        let sequence = [
            getInterval(wordId: wordId, ansType: type, type: .easy, badValue: false).map({ ($0, false, AnswersRaw.easy) }),
            getInterval(wordId: wordId, ansType: type, type: .hard, badValue: false).map({ ($0, false, AnswersRaw.hard) }),
            getInterval(wordId: wordId, ansType: type, type: .hard, badValue: true).map({ ($0, true, AnswersRaw.hard) })
        ]
        
        return Observable.zip(sequence, { (results) -> IntervalsModel in
            
            return IntervalsModel(easy: results.first(where: { $0.2 == AnswersRaw.easy })!.0,
                                  hard: results.first(where: { $0.2 == AnswersRaw.hard && !$0.1 })!.0,
                                  badHard: results.first(where: { $0.2 == AnswersRaw.hard && $0.1 })!.0,
                                  forget: 0)
        })
    }
    
    private func getInterval(wordId: String, ansType: AnswersType, type: AnswersRaw, badValue: Bool) -> Observable<Int> {
        return _statisticsRepositories.getElementFor(wordsId: [wordId])
            .map({ sinq($0).whereTrue({ $0.type == ansType }).first() })
            .map({ self._smEngine.calculateInterval(statistics: $0, type: type, badValue: badValue) })
    }
    
    func updateStatistics(answer: Answer, type: AnswersType) -> Observable<Bool> {
        return _statisticsRepositories.getElementFor(wordsId: [answer.id])
            .map({ sinq($0).whereTrue({ $0.type == type }).first() })
            .flatMap({ (statistics) -> Observable<Bool> in
                let newStat = self._smEngine.gradeFlashcard(statistics: statistics, answer: answer)
                return Observable.concat([
                    self._statisticsRepositories.updateStatistics(statistics: newStat),
                    self._answerRepositories.updateAnswer(model: AnswerApiModel(id: nil,
                                                                                dateCreated: Date(),
                                                                                wordId: answer.id,
                                                                                type: type,
                                                                                grade: newStat.lastAnswer!.answer,
                                                                                miliSecondsForReview: answer.totalMiliseconds))
                    ])
            })
    }
}
