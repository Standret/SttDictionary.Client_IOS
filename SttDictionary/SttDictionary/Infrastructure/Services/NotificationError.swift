//
//  NotificationError.swift
//  SttDictionary
//
//  Created by Admin on 5/20/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

protocol INotificationError {
    var errorObservable: Observable<(String, String)> { get }
    
    func useError<T>(observable: Observable<T>) -> Observable<T>
}

class NotificationError: INotificationError {
    
    let subject = PublishSubject<(String, String)>()
    
    var errorObservable: Observable<(String, String)> { return subject }
    
    func useError<T>(observable: Observable<T>) -> Observable<T> {
        return observable.do(onError: { (error) in
            if let er = error as? BaseError {
                self.subject.onNext(er.getMessage())
            }
            else {
                self.subject.onNext(("Unkown", "\(error)"))
            }
        })
    }
}
