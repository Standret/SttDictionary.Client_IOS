//
//  StudyPresenter.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/3/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol StudyDelegate: SttViewControlable {
    func reloadStatus()
}

class StudyPresenter: SttPresenter<StudyDelegate> {
    
    var newWords = [WordApiModel]()
    var repeatWords = [WordApiModel]()
    var newTranslationWords = [WordApiModel]()
    var repeatTranslationWords = [WordApiModel]()
    
    var _studyInteractor: StudyInteractorType!
    
    var reload: SttComand!
    
    override func presenterCreating() {
        super.presenterCreating()
        ServiceInjectorAssembly.instance().inject(into: self)
        
        reload = SttComand(delegate: self, handler: { $0.reloadData() })
        reload.concurentExecute = true
    }
    
    func reloadData() {
        _ = _studyInteractor.getStudyData()
            .subscribe(onNext: { [weak self] (result) in
                self?.newWords = result.newOriginal
                self?.newTranslationWords = result.newTranslate
                self?.repeatWords = result.repeatOriginal
                self?.repeatTranslationWords = result.repeatTranslation
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
