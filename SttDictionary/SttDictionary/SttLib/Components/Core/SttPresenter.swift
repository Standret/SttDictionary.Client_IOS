//
//  SttPresenter.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

protocol SttPresenterType: class { }

class SttPresenter<TDelegate> : SttViewInjector, SttPresenterType {
    
    private weak var _delegate: SttViewable?
    var delegate: TDelegate? { return _delegate as? TDelegate }
    
    weak var _notificationError: NotificationErrorType!
    
    required init() { }
    func injectView(delegate: SttViewable) {
        ServiceInjectorAssembly.instance().inject(into: self)
        self._delegate = delegate
        
        _ = _notificationError.errorObservable.subscribe(onNext: { [weak self] (err) in
            if (self?._delegate is SttViewableListener) {
                (self!._delegate as! SttViewableListener).sendError(error: err)
            }
        })
        presenterCreating()
    }
    
    func presenterCreating() { }
    
    func prepare(parametr: Any?) { }
}
