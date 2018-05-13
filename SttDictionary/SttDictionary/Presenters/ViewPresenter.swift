//
//  ViewPresenter.swift
//  SttDictionary
//
//  Created by Admin on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol ViewDelegate: Viewable {
    
}

class ViewPresenter: SttPresenter<ViewDelegate> {
    var _apiService: IApiService!
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    func getTags() {
        _apiService.getTags().subscribe(onNext: { (tags) in
            print(tags)
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            print("completed")
        }) {
            print("disposed")
        }
        _apiService.getWord().subscribe(onNext: { (tags) in
            print(tags)
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            print("completed")
        }) {
            print("disposed")
        }
    }

}
