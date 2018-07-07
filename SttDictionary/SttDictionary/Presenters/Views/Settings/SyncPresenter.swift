//
//  SyncPresenter.swift
//  SttDictionary
//
//  Created by Admin on 5/20/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

protocol SyncDelegate: SttViewContolable {
    func updateData(date: String, count: CountViewModel)
    func loadCompleted()
}

class SyncPresenter: SttPresenter<SyncDelegate> {
    
    var _syncService: ISyncService!
    var _syncInteractor: SyncInteractorType!
    
    var sync: SttComand!
    var send: SttComand!
    var update: SttComand!
    
    private var countData: CountViewModel! {
        didSet {
            delegate?.updateData(date: "unsupportd", count: countData)
        }
    }
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        
        _ = _syncInteractor.getCount()
            .subscribe(onNext: { (data) in
                self.countData = data
                self.delegate?.loadCompleted()
            }, onError: { _ in self.delegate?.loadCompleted() })
        
        sync = SttComand(delegate: self, handler: { $0.onSync() })
        send = SttComand(delegate: self, handler: { $0.onSend() })
        update = SttComand(delegate: self, handler: { $0.onUpdate() })
        sync.singleCallEndCallback = false
        send.singleCallEndCallback = false
        update.singleCallEndCallback = false
    }
    
    func onSync() {
        self.countData.localAll = CountApiModel(countOfWords: 0, countOfTags: 0, countOfStatistics: 0, countOfAnswers: 0)
        self.delegate?.updateData(date: "unsupported", count: self.countData)
        _ = sync.useWork(observable: _syncInteractor.syncData())
            .subscribe(onNext: { (arg) in
                let (step, count) = arg
                
                switch step {
                case .word:
                    self.countData.localAll.countOfWords = count
                case .answer:
                    self.countData.localAll.countOfAnswers = count
                case .tag:
                    self.countData.localAll.countOfTags = count
                case .wordStatistics:
                    self.countData.localAll.countOfStatistics = count
                case .uploadWord:
                    self.countData.localNewNotSynced.countOfWords -= count
                case .uploadTag:
                    self.countData.localNewNotSynced.countOfTags -= count
                case .uploadAnswer:
                    self.countData.localNewNotSynced.countOfAnswers -= count
                default: break
                }
                self.delegate?.updateData(date: "unsupported", count: self.countData)
            })
    }
    
    func onSend() {
        self.countData.localAll = CountApiModel(countOfWords: 0, countOfTags: 0, countOfStatistics: 0, countOfAnswers: 0)
        self.delegate?.updateData(date: "unsupported", count: self.countData)
        _ = send.useWork(observable: _syncInteractor.sendData())
            .subscribe(onNext: { (arg) in
                let (step, count) = arg
                
                switch step {
                case .uploadWord:
                    self.countData.localNewNotSynced.countOfWords -= count
                case .uploadTag:
                    self.countData.localNewNotSynced.countOfTags -= count
                case .uploadAnswer:
                    self.countData.localNewNotSynced.countOfAnswers -= count
                default: break
                }
                self.delegate?.updateData(date: "unsupported", count: self.countData)
            })
    }
    func onUpdate() {
        _ = update.useWork(observable: _syncInteractor.updateData())
            .subscribe(onNext: { (arg) in
                let (step, count) = arg
                
                switch step {
                case .word:
                    self.countData.localAll.countOfWords = count
                case .answer:
                    self.countData.localAll.countOfAnswers = count
                case .tag:
                    self.countData.localAll.countOfTags = count
                case .wordStatistics:
                    self.countData.localAll.countOfStatistics = count
                default: break
                }
                self.delegate?.updateData(date: "unsupported", count: self.countData)
            })
    }
}
