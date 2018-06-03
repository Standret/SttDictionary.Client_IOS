//
//  StudyPresenter.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/3/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol StudyDelegate: Viewable {
    func reloadStatus()
}

class StudyPresenter: SttPresenter<StudyDelegate> {
    
    var newWords = [RealmWord]()
    var repeatWords = [RealmWord]()
    
    var _wordService: IWordService!
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        
        super.presenterCreating()
        _ = _wordService.getNewWord()
            .subscribe(onNext: { [weak self] (words) in
                self?.newWords = words
                self?.delegate.reloadStatus()
            })
        _  = _wordService.getRepeatWord()
            .subscribe(onNext: { [weak self] (words) in
                self?.repeatWords = words
                self?.delegate.reloadStatus()
            })
    }
    
    func onCLickOriginalCard() {
        delegate.navigate(to: "showCard", withParametr: (newWords, repeatWords), callback: nil)
    }
}
