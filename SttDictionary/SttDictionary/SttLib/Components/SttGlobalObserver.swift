//
//  SttGlobalObserver.swift
//  SttDictionary
//
//  Created by Standret on 22.06.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

public enum SttApplicationStatus {
    case EnterBackgound
    case EnterForeground
}

public class SttGlobalObserver {
    private static let publisher = PublishSubject<SttApplicationStatus>()
    
    public static var observableStatusApplication: Observable<SttApplicationStatus> { return publisher }
    
    public class func applicationStatusChanged(status: SttApplicationStatus) {
        publisher.onNext(status)
    }
}
