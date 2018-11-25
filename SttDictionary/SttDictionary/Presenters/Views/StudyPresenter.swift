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
    
    var studyData: StudyWordsModel!
    
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
                self?.studyData = result
                self?.delegate?.reloadStatus()
            })
    }
    
    func onCLickOriginalCard() {
        if self.studyData.newOriginal.count > 0 || self.studyData.repeatOriginal.count > 0 {
            delegate?.navigate(to: "showCard",
                               withParametr: CardNavigate(newWords: studyData.newOriginal, repeatWords: studyData.repeatOriginal,
                                                          extraordinaryWords: studyData.extraordinaryOriginal, type: .originalCard),
                               callback: nil)
        }
        else {
            delegate?.sendMessage(title: "Warning", message: "You have not any words to trained today")
        }
    }
    func onClickTranslateCard() {
        if self.studyData.newTranslate.count > 0 || self.studyData.repeatTranslation.count > 0 {
            delegate?.navigate(to: "showCard",
                               withParametr: CardNavigate(newWords: studyData.newTranslate, repeatWords: studyData.repeatTranslation,
                                                          extraordinaryWords: studyData.extraordinaryTranslation, type: .translateCard),
                               callback: nil)
        }
        else {
            delegate?.sendMessage(title: "Warning", message: "You have not any words to trained today")
        }
    }
}
