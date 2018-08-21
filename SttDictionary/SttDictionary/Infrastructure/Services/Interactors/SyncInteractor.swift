//
//  SyncInteractor.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/7/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

enum SyncStepComponent {
    case word, tag
    case wordStatistics, answer
    case uploadWord, uploadTag, uploadAnswer
    case remove
}

protocol SyncInteractorType {
    func countOf(type: ElementType) -> Observable<Int>
    func getCount() -> Observable<CountViewModel>
    
    func syncData() -> Observable<(SyncStepComponent, Int)>
    func updateData() -> Observable<(SyncStepComponent, Int)>
    func sendData() -> Observable<(SyncStepComponent, Int)>
}

class SyncInteractor: SyncInteractorType {
    
    var _wordRepositories: WordRepositoriesType!
    var _statisticsRepositories: StatisticsRepositoriesType!
    var _tagRepositories: TagRepositoriesType!
    var _answerRepositories: AnswerRepositoriesType!
    
    var _notificationError: NotificationErrorType!
    
    init() {
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    func countOf(type: ElementType) -> Observable<Int> {
        return _notificationError.useError(observable: _wordRepositories.getWords(type: type).map({ $0.count }))
    }
    
    func syncData() -> Observable<(SyncStepComponent, Int)> {
        return Observable.concat([sendData(), updateData()])
    }
    
    func getCount() -> Observable<CountViewModel> {
        let localNotSynced = Observable.zip(getLocalCount(type: .newNotSynced), getLocalCount(type: .notSynced), resultSelector: { ($0, $1) })
        let countAll = Observable.zip(getLocalCount(type: .all), _statisticsRepositories.getCount(), resultSelector: { ($0, $1) })
        
        return _notificationError.useError(observable:
            Observable.zip(localNotSynced, countAll,
                           resultSelector: { CountViewModel(localAll: $1.0, localNotSynced: $0.1, localNewNotSynced: $0.0, serverAll: $1.1) })
            .inBackground()
            .observeInUI())
    }
    
    func sendData() -> Observable<(SyncStepComponent, Int)> {
        return _notificationError.useError(observable:
            Observable.concat([
                _wordRepositories.addCachedWords().map({ _ in (SyncStepComponent.uploadWord, 1) }),
                _tagRepositories.addCachedTags().map({ _ in (SyncStepComponent.uploadTag, 1) }),
                _answerRepositories.addCachedAnswers().map({ (SyncStepComponent.uploadAnswer, $0) }),
                _answerRepositories.getCount(type: .all)
                    .flatMap({ count in Observable<(SyncStepComponent, Int)>.create({ self.updateAnswers(skip: count, observer: $0) }) })
                ])
            .inBackground()
            .observeInUI())
    }
    
    func updateData() -> Observable<(SyncStepComponent, Int)> {
        return _notificationError.useError(observable:
            Observable.concat([
                Observable.concat([
                    _wordRepositories.removeAll().toObservable(),
                    _answerRepositories.removeAll().toObservable(),
                    _tagRepositories.removeAll().toObservable(),
                    _statisticsRepositories.removeAll().toObservable(),
                    ]).map({ _ in (SyncStepComponent.remove, 0) }),
                Observable<(SyncStepComponent, Int)>.create({ self.updateWords(skip: 0, observer: $0) }),
                Observable<(SyncStepComponent, Int)>.create({ self.updateTags(skip: 0, observer: $0) }),
                Observable<(SyncStepComponent, Int)>.create({ self.updateWordStatistics(skip: 0, observer: $0) }),
                Observable<(SyncStepComponent, Int)>.create({ self.updateAnswers(skip: 0, observer: $0) })
                ])
            .inBackground()
            .observeInUI())
    }
    
    private func getLocalCount(type: ElementType) -> Observable<CountApiModel> {
        return Observable.zip(Observable.zip(_wordRepositories.getCount(type: type),
                                             _tagRepositories.getCount(type: type),
                                             resultSelector: { ($0, $1) }),
                              Observable.zip(_statisticsRepositories.getLocalCount(type: type),
                                             _answerRepositories.getCount(type: type),
                                             resultSelector: { ($0, $1) }),
                              resultSelector: { CountApiModel(countOfWords: $0.0, countOfTags: $0.1, countOfStatistics: $1.0, countOfAnswers: $1.1) })
    }
    
    private func updateWords(skip: Int, observer: AnyObserver<(SyncStepComponent, Int)>) -> Disposable {
        return _wordRepositories.updateWords(skip: skip)
            .subscribe(onNext: { (count) in
                if count > 0 {
                    observer.onNext((SyncStepComponent.word, skip + count))
                    _ = self.updateWords(skip: skip + count, observer: observer)
                }
                else {
                    observer.onCompleted()
                }
            }, onError: observer.onError(_:))
    }
    private func updateTags(skip: Int, observer: AnyObserver<(SyncStepComponent, Int)>) -> Disposable {
        return _tagRepositories.updateTag(skip: skip)
            .subscribe(onNext: { (count) in
                if count > 0 {
                    observer.onNext((SyncStepComponent.tag, skip + count))
                    _ = self.updateTags(skip: skip + count, observer: observer)
                }
                else {
                    observer.onCompleted()
                }
            }, onError: observer.onError(_:))
    }
    private func updateWordStatistics(skip: Int, observer: AnyObserver<(SyncStepComponent, Int)>) -> Disposable {
        return _statisticsRepositories.updateStatistics(skip: skip)
            .subscribe(onNext: { (count) in
                if count > 0 {
                    observer.onNext((SyncStepComponent.wordStatistics, skip + count))
                    _ = self.updateWordStatistics(skip: skip + count, observer: observer)
                }
                else {
                    observer.onCompleted()
                }
            }, onError: observer.onError(_:))
    }
    private func updateAnswers(skip: Int, observer: AnyObserver<(SyncStepComponent, Int)>) -> Disposable {
        return _answerRepositories.updateAnswer(skip: skip)
            .subscribe(onNext: { (count) in
                if count > 0 {
                    observer.onNext((SyncStepComponent.answer, skip + count))
                    _ = self.updateAnswers(skip: skip + count, observer: observer)
                }
                else {
                    observer.onCompleted()
                }
            }, onError: observer.onError(_:))
    }
}
