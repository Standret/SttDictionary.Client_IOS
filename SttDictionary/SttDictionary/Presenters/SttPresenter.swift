//
//  SttPresenter.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

class SttPresenter<TDelegate> : ViewInjector {

    var delegate: TDelegate!
    
    var _notificationError: INotificationError!
    
    required init() { }
    func injectView(delegate: Viewable) {
        ServiceInjectorAssembly.instance().inject(into: self)
        self.delegate = delegate as! TDelegate
        
        _ = _notificationError.errorObservable.subscribe(onNext: { (error) in
            if self.delegate is Viewable {
                (self.delegate as! Viewable).sendError(title: error.0, message: error.1)
            }
            else {
                print(error)
            }
        })
        presenterCreating()
    }
    
    func presenterCreating() { }
}
