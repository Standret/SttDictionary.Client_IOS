//
//  SttComand.swift
//  SttDictionary
//
//  Created by Standret on 5/19/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

class SttComand {
    
    private var handlerStart: (() -> Void)?
    private var handlerEnd: (() -> Void)?
    private var executeHandler: (() -> Void)
    private var canExecuteHandler: (() -> Bool)?
    
    var singleCallEndCallback = true
    private var isCall = false
    
    init<T: SttPresenterType> (delegate: T, handler: @escaping (T) -> Void, handlerCanExecute: ((T) -> Bool)? = nil) {
        executeHandler = { [weak delegate] in
            if let _delegate = delegate {
                handler(_delegate)
            }
        }
        canExecuteHandler = { [weak delegate] in
            if let _delegate = delegate {
                if let _handlerCanExecute = handlerCanExecute {
                    return _handlerCanExecute(_delegate)
                }
            }
            return true
        }
        isCall = false
    }

    func addHandler(start: (() -> Void)?, end: (() -> Void)?) {
        handlerStart = start
        handlerEnd = end
    }
    
    func execute() {
        if canExecute() {
            if let handler = handlerStart {
                handler()
            }
            executeHandler()
        }
        else {
            SttLog.trace(message: "Command could not be execute", key: "SttComand")
        }
    }
    func canExecute() -> Bool {
        if let handler = canExecuteHandler {
            return handler()
        }
        return true
    }
}

extension SttComand {
    func useWork<T>(observable: Observable<T>) -> Observable<T> {
        return observable.do(onNext: { (element) in
            if self.handlerEnd != nil && self.singleCallEndCallback && !self.isCall {
                self.handlerEnd!()
                self.isCall = false
            }
        }, onError: { (error) in
            if self.handlerEnd != nil && !self.isCall {
                self.handlerEnd!()
                self.isCall = false
            }
        }, onCompleted: {
            if self.handlerEnd != nil && !self.isCall {
                self.handlerEnd!()
                self.isCall = false
            }
        })
    }
}

