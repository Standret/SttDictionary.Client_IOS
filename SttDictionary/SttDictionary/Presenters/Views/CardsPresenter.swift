//
//  CardsPresenter.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/3/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import SINQ
import RxSwift

struct Answer {
    var id: String
    var type: AnswersRaw
    var totalMiliseconds: Int
}

protocol CardsDelegate: SttViewControlable {
    func reloadWords(word: String, url: String?, example: (String, String)?, isNew: Bool, useVoice: Bool)
    func showFinalPopup(message: String)
    func updateIntervals(intervals: IntervalsModel)
}

class CardsPresenter: SttPresenter<CardsDelegate> {
    
    var words = [WordApiModel]()
    var answers = [Answer]()
    var current: Int { return _current }
    
    private var _current = 0
    private var totalMiliSeconds = 0
    private var wordMiliseconds = 0
    var goodAnwerExpires: Bool { return wordMiliseconds > Constants.timeForPass }
    
    private var generalTimer: Timer!
    private var wordTimer: Timer!
    private var answerType: AnswersType!
    private var useVoice: Bool { return answerType == .originalCard && words[current].usePronunciation }
    
    var _wordInteractor: WordInteractorType!
    
    override func prepare(parametr: Any?) {
        ServiceInjectorAssembly.instance().inject(into: self)

        let param = parametr as! ([WordApiModel], [WordApiModel], AnswersType)
        answerType = param.2
        
        initializeWords(_words: (param.0, param.1))
        
        showNext()
        
        generalTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (timer) in
            self?.totalMiliSeconds += 100
        })
        reloadWordTimer()
        generalTimer.fire()
    }
    
    func showAnswer() {
        let text = answerType == .originalCard ? words[current].translations.joined(separator: ", ") : words[current].originalWorld
        let example = answerType == .originalCard ? (words[current].exampleUsage?.translate ?? "", words[current].explanation ?? "") : (words[current].exampleUsage?.original ?? "", words[current].explanation ?? "")
        delegate?.reloadWords(word: text, url: words[current].pronunciationUrl, example: example, isNew: false, useVoice: words[current].usePronunciation)
    }
    
    func selectAnswer(type: AnswersRaw) {
        answers.append(Answer(id: words[_current].id, type: type, totalMiliseconds: wordMiliseconds))
        _ = _wordInteractor.updateStatistics(answer: answers.last!, type: answerType)
            .subscribe(onNext: { print("stat has been updated successfuly \($0)") }, onError: { print("stat er \($0)") })
        _current += 1
        if current < words.count{
            showNext()
        }
        else {
            generalTimer.invalidate()
            let badCount = sinq(answers).whereTrue( { $0.type == AnswersRaw.forget } ).count()
            delegate?.showFinalPopup(message: "spend time: \(totalMiliSeconds / 1000)s\nneed repeat today: \(badCount)")
            print("final: \(totalMiliSeconds)")
            for item in answers {
                print("id: \(item.id) answer: \(item.type) m: \(item.totalMiliseconds)")
            }
        }
    }
    
    private func reloadWordTimer() {
        wordTimer?.invalidate()
        wordMiliseconds = 0
        var isShow = false
        wordTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (timer) in
            self!.wordMiliseconds += 100
            if (self!.goodAnwerExpires && !isShow) {
                isShow = true
                self!.delegate?.updateIntervals(intervals: self!.intervals)
            }
        })
    }
    
    private var intervals: IntervalsModel!
    private var disposable: Disposable?
    private func showNext() {
        let text = answerType == .originalCard ? words[current].originalWorld : words[current].translations.joined(separator: ", ")
        let example = answerType == .originalCard ? (words[current].exampleUsage?.original ?? "", words[current].explanation ?? "") : (words[current].exampleUsage?.translate ?? "", words[current].explanation ?? "")
        delegate?.reloadWords(word: text, url: words[current].pronunciationUrl, example: example, isNew: true, useVoice: useVoice)
        reloadWordTimer()
        
        disposable?.dispose()
        disposable = _wordInteractor.getIntervals(wordId: words[current].id, type: answerType)
            .subscribe(onNext: { intervals in
                self.intervals = intervals
                self.delegate?.updateIntervals(intervals: intervals)
            })

    }
    
    /// initialize target collection using (start end method) and radom sort
    private func initializeWords(_words: ([WordApiModel], [WordApiModel])) {
        
        var param = _words
        var cardsCount = param.0.count + param.1.count
        if cardsCount > Constants.countCardsPerSession && cardsCount > (Constants.minCardsPerSession * 2) {
            let newSelectCount = param.0.count * Constants.countCardsPerSession / cardsCount
            let repeatSelectCount = Constants.countCardsPerSession - newSelectCount
            
            print ("news: \(newSelectCount) | repeat: \(repeatSelectCount)")
            let newWordSelectIndexes = SttRandom.radomIndex(start: 0, end: UInt32(param.0.count), count: newSelectCount)
            let repeatSelectIndexes = SttRandom.radomIndex(start: 0, end: UInt32(param.1.count), count: repeatSelectCount)
            
            param.0 = param.0.getElement(indexes: newWordSelectIndexes)
            param.1 = param.1.getElement(indexes: repeatSelectIndexes)
        }
        cardsCount = param.0.count + param.1.count
        
        var vector = [Bool]()
        for i in 0...cardsCount {
            vector.append(SttRandom.boolRandom(k: i / 10 % 3))
        }
        
        var left = 0
        print((cardsCount - (cardsCount % 2 == 0 ? 1 : 0)) / 2)
        for i in 0...((cardsCount - (cardsCount % 2 == 0 ? 1 : 0)) / 2) {
            // start
            if vector[i] && param.1.count > 0 {
                print("insert repeat word in \(i)")
                words.insert(param.1.getAndDelete(index: 0), at: left)
            }
            else if param.0.count > 0 {
                print("insert new words in \(i)")
                words.insert(param.0.getAndDelete(index: 0), at: left)
            }
            else if param.1.count > 0 {
                print("insert repeat word in \(i)")
                words.insert(param.1.getAndDelete(index: 0), at: left)
            }
            else {
                fatalError("invalid algorithm")
            }
            left += 1
            
            // end
            if vector[cardsCount - i - 1] && param.1.count > 0 {
                print("insert repeat word in \(cardsCount - i - 1)")
                words.insert(param.1.getAndDelete(index: 0), at: left)
            }
            else if param.0.count > 0 {
                print ("insert net words in \(cardsCount - i - 1)")
                words.insert(param.0.getAndDelete(index: 0), at: left)
            }
            else if param.1.count > 0 {
                print("insert repeat word in \(cardsCount - i - 1)")
                words.insert(param.1.getAndDelete(index: 0), at: left)
            }
        }
        
        for item in words {
            print(item.originalWorld)
        }
    }
}
