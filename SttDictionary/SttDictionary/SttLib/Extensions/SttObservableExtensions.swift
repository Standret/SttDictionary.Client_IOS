//
//  ObservableTypeExt.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

extension PrimitiveSequence {
    func toEmptyObservable<T>(ofType _: T.Type) -> Observable<T> {
        return self.asObservable().flatMap({ _ in Observable<T>.empty() })
    }
    func toObservable() -> Observable<Bool> {
        return Observable<Bool>.create({ (observer) -> Disposable in
            self.asObservable().subscribe(onCompleted: {
                observer.onNext(true)
                observer.onCompleted()
            })
        })
    }
    func inBackground() -> PrimitiveSequence<Trait, Element> {
        return self.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
    func observeInUI() -> PrimitiveSequence<Trait, Element> {
        return self.observeOn(MainScheduler.instance)
    }
}

extension Observable {
    func saveInDB(saveCallback: @escaping (_ saveCallback: Element) -> Completable) -> Observable<Element>
    {
        return self.map({ (element) -> Element in
            _ = saveCallback(element).subscribe(onCompleted: {
                SttLog.trace(message: "\(type(of: Element.self)) has been saved succefully in realm", key: Constants.repositoryExtensionsLog)
            }, onError: { (error) in
                SttLog.error(message: "\(type(of: Element.self)) could not save in db", key: Constants.repositoryExtensionsLog)
            })
            return element
        })
    }
    
    func inBackground() -> Observable<Element> {
        return self.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
    func observeInUI() -> Observable<Element> {
        return self.observeOn(MainScheduler.instance)
    }
}
