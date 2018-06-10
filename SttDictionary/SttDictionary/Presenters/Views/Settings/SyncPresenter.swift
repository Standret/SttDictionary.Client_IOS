//
//  SyncPresenter.swift
//  SttDictionary
//
//  Created by Admin on 5/20/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol SyncDelegate: Viewable {
    func updateData(date: String, countLocal: Int, countServer: Int)
}

class SyncPresenter: SttPresenter<SyncDelegate> {
    
    var _syncService: ISyncService!
    
    var sync: SttComand!
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        
        _ = _syncService.getSyncData().subscribe(onNext: { (result) in
            self.delegate.updateData(date: DateConverter().convert(value: result.dateOfLastSync), countLocal: result.countLocal, countServer: result.countServer)
        }, onError: { (error) in
            print(error)
        })
        
        _ = _syncService.observe.subscribe(onNext: { (model) in
            self.delegate.updateData(date: DateConverter().convert(value: model.dateOfLastSync), countLocal: model.countLocal, countServer: model.countServer)
        })
        
        sync = SttComand(delegate: self, handler: { $0.onSync() })
    }
    
    func onSync() {
        _ = sync.useWork(observable: _syncService.sync()).subscribe(onNext: { (result) in
            print("\(result.0): \(result.1)")
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            print("completed")
        })
    }
}
