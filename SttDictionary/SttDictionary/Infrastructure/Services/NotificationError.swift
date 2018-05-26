//
//  NotificationError.swift
//  SttDictionary
//
//  Created by Admin on 5/20/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

protocol INotificationError: class {
    var errorObservable: Observable<BaseError> { get }
    
    func useError<T>(observable: Observable<T>, ignoreBadRequest: Bool) -> Observable<T>
}

extension INotificationError {
    func useError<T>(observable: Observable<T>, ignoreBadRequest: Bool = false) -> Observable<T> {
        return self.useError(observable: observable, ignoreBadRequest: ignoreBadRequest)
    }
    
}

class NotificationError: INotificationError {
    
    let subject = PublishSubject<BaseError>()
    
    var errorObservable: Observable<BaseError> { return subject }
    
    func useError<T>(observable: Observable<T>, ignoreBadRequest: Bool) -> Observable<T> {
        return observable.do(onError: { (error) in
            if let er = error as? BaseError {
                var flag = true
                if ignoreBadRequest {
                    switch er {
                    case .apiError(let api):
                        switch api {
                        case .badRequest( _):
                            flag = false
                        default: break
                        }
                    default: break
                    }
                }
                if flag {
                    self.subject.onNext(er)
                }
            }
            else {
                self.subject.onNext(BaseError.unkown("\(error)"))
            }
        })
    }
}
