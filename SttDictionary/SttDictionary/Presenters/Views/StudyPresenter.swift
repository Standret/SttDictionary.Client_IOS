//
//  StudyPresenter.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/3/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol StudyDelegate: SttViewContolable {
    func reloadStatus()
}

class StudyPresenter: SttPresenter<StudyDelegate> {
    
    var newWords = [RealmWord]()
    var repeatWords = [RealmWord]()
    var newTranslationWords = [RealmWord]()
    var repeatTranslationWords = [RealmWord]()
    
    var _wordService: IWordService!
    
    override func presenterCreating() {
        super.presenterCreating()
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    func reloadData() {
        _ = _wordService.getNewWord()
            .subscribe(onNext: { [weak self] (words) in
                self?.newWords = words
                self?.delegate?.reloadStatus()
            })
        _  = _wordService.getRepeatWord()
            .subscribe(onNext: { [weak self] (words) in
                self?.repeatWords = words
                self?.delegate?.reloadStatus()
            })
        _ = _wordService.getNewTranslationWord()
            .subscribe(onNext: { [weak self] (words) in
                self?.newTranslationWords = words
                self?.delegate?.reloadStatus()
            })
        _  = _wordService.getRepeatTranslationWord()
            .subscribe(onNext: { [weak self] (words) in
                self?.repeatTranslationWords = words
                self?.delegate?.reloadStatus()
            })
    }
    
    func onCLickOriginalCard() {
        if newWords.count > 0 || repeatWords.count > 0 {
            delegate?.navigate(to: "showCard", withParametr: (newWords, repeatWords, AnswersType.originalCard), callback: nil)
        }
        else {
            delegate?.sendMessage(title: "Warning", message: "You have not any words to trained today")
        }
    }
    func onClickTranslateCard() {
        if newTranslationWords.count > 0 || repeatTranslationWords.count > 0 {
            delegate?.navigate(to: "showCard", withParametr: (newTranslationWords, repeatTranslationWords, AnswersType.translateCard), callback: nil)
        }
        else {
            delegate?.sendMessage(title: "Warning", message: "You have not any words to trained today")
        }
    }
}
