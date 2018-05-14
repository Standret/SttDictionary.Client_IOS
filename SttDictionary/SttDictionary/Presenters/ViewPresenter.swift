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
    var _unitOfWorkd: IUnitOfWork!
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    func getTags() {

        _apiService.getWord().subscribe(onNext: { (tags) in
            print(tags)
            self._unitOfWorkd.word.save(models: tags).subscribe(onNext: { (suc) in
                print("--> save word success")
                self._apiService.getTags().subscribe(onNext: { (_tags) in
                    print(tags)
                    self._unitOfWorkd.tag.save(models: _tags).subscribe(onNext: { (res) in
                        print("--> save tag success")
                    }, onError: { (err) in
                        print("save tag error")
                    }, onCompleted: nil, onDisposed: nil)
                }, onError: { (error) in
                    print(error)
                }, onCompleted: {
                    print("completed")
                }) {
                    print("disposed")
                }
            }, onError: { (error) in
                print("--> error save word \(error)")
            }, onCompleted: nil, onDisposed: nil)
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            print("completed")
        }) {
            print("disposed")
        }
    }

}
