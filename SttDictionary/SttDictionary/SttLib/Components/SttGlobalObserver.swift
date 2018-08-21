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
    case didEnterBackgound
    case willEnterForeground
    case wilTerminate
}

public class SttGlobalObserver {
    private static let publisher = PublishSubject<SttApplicationStatus>()
    
    public static var observableStatusApplication: Observable<SttApplicationStatus> { return publisher }
    
    public class func applicationStatusChanged(status: SttApplicationStatus) {
        publisher.onNext(status)
    }
}

public class SttAppLifecycle
{
    public class func didEnterBackground() {
        SttGlobalObserver.applicationStatusChanged(status: .didEnterBackgound)
    }
    
    public class func willEnterForeground() {
        SttGlobalObserver.applicationStatusChanged(status: .willEnterForeground)
    }
    
    public class func willTerminate() {
        SttGlobalObserver.applicationStatusChanged(status: .wilTerminate)
    }
}
