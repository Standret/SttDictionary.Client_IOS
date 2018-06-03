//
//  CardsPresenter.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/3/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import SINQ

enum TypeAnswer {
    case forget, hard, easy
}

struct Answer {
    var id: String
    var type: TypeAnswer
    var answerType: AnswersType
    var totalMiliseconds: Int
}

protocol CardsDelegate: Viewable {
    func reloadWords(word: String, isNew: Bool)
    func showFinalPopup(message: String)
}

class CardsPresenter: SttPresenter<CardsDelegate> {
    
    var words = [RealmWord]()
    var answers = [Answer]()
    var current: Int { return _current }
    
    private var _current = 0
    private var totalMiliSeconds = 0
    private var wordMiliseconds = 0
    
    private var generalTimer: Timer!
    private var wordTimer: Timer!
    
    var _wordService: IWordService!
    
    override func prepare(parametr: Any?) {
        ServiceInjectorAssembly.instance().inject(into: self)

        let param = parametr as! ([RealmWord], [RealmWord])
        
        initializeWords(_words: param)
        delegate.reloadWords(word: words[0].originalWorld, isNew: true)
        
        generalTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (timer) in
            self?.totalMiliSeconds += 100
        })
        reloadWordTimer()
        generalTimer.fire()
    }
    
    func showAnswer() {
        delegate.reloadWords(word: words[current].translations.map({ $0.value }).joined(separator: ", "), isNew: false)
    }
    func selectAnswer(type: TypeAnswer) {
        answers.append(Answer(id: words[_current].id, type: type, answerType: .originalCard, totalMiliseconds: wordMiliseconds))
        _ = _wordService.updateStatistics(answer: answers.last!)
            .subscribe(onNext: { print("stat has been updated successfuly \($0)") }, onError: { print("stat er \($0)") })
        _current += 1
        if current < words.count{
            delegate.reloadWords(word: words[current].originalWorld, isNew: true)
            reloadWordTimer()
        }
        else {
            generalTimer.invalidate()
            let badCount = sinq(answers).whereTrue( { $0.type == TypeAnswer.forget } ).count()
            delegate.showFinalPopup(message: "spend time: \(totalMiliSeconds / 1000)s\nneed repeat today: \(badCount)")
            print("final: \(totalMiliSeconds)")
            for item in answers {
                print("id: \(item.id) answer: \(item.type) m: \(item.totalMiliseconds)")
            }
        }
    }
    
    private func reloadWordTimer() {
        wordTimer?.invalidate()
        wordMiliseconds = 0
        wordTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (timer) in
            self?.wordMiliseconds += 100
        })
    }
    
    private func initializeWords(_words: ([RealmWord], [RealmWord])) {
        
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
        for i in 0...((cardsCount / 2) - cardsCount % 2 == 0 ? 1 : 0) {
            // start
            if vector[i] && param.1.count > 0 {
                words.insert(param.1.getAndDelete(index: 0), at: left)
            }
            else if param.0.count > 0 {
                print("insert new words in \(i)")
                words.insert(param.0.getAndDelete(index: 0), at: left)
            }
            else if param.1.count > 0 {
                words.insert(param.1.getAndDelete(index: 0), at: left)
            }
            else {
                fatalError("invalid algorithm")
            }
            left += 1
            
            // end
            if vector[cardsCount - i - 1] && param.1.count > 0 {
                words.insert(param.1.getAndDelete(index: 0), at: left)
            }
            else if param.0.count > 0 {
                print ("insert net words in \(cardsCount - i - 1)")
                words.insert(param.0.getAndDelete(index: 0), at: left)
            }
            else if param.1.count > 0 {
                words.insert(param.1.getAndDelete(index: 0), at: left)
            }
        }
    }
}
