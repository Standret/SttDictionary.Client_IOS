//
//  RxComand.swift
//  SttDictionary
//
//  Created by Admin on 5/19/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

class RxComand {
    
    private var handlerStart: (() -> Void)?
    private var handlerEnd: (() -> Void)?
    private var executeHandler: (() -> Void)
    
    var endIfReceiveFirstNext = true
    
    init (handler: @escaping () -> Void) {
        executeHandler = handler
    }
    
    func addHandler(start: (() -> Void)?, end: (() -> Void)?) {
        handlerStart = start
        handlerEnd = end
    }
    
    func execute() {
        if let handler = handlerStart {
            handler()
        }
        executeHandler()
    }
    
    
}

extension RxComand {
    func useWork<T>(observable: Observable<T>) -> Observable<T> {
        return observable.do(onNext: { (element) in
            if self.handlerEnd != nil && self.endIfReceiveFirstNext {
                self.handlerEnd!()
                self.handlerEnd = nil
            }
        }, onError: { (error) in
            if let handler = self.handlerEnd {
                handler()
                self.handlerEnd = nil
            }
        }, onCompleted: {
            if let handler = self.handlerEnd {
                handler()
                self.handlerEnd = nil
            }
        })
    }
}
