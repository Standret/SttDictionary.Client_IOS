//
//  ViewPresenter.swift
//  SttDictionary
//
//  Created by Admin on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol ViewDelegate: SttViewable {
    
}

class ViewPresenter: SttPresenter<ViewDelegate> {
    var _apiService: ApiDataProviderType!
    var _unitOfWorkd: RealmStorageProviderType!
    
    override func presenterCreating() {
        //ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    func getTags() {

        //_ = _apiService.updateTags().subscribe(onNext: { (tags) in
            //print("Recieve isLocal: \(tags.isLocal) isSuccess: \(tags.isSuccess)")
           // print("\n\n\n")
               // return self._apiService.getTags().subscribe(onNext: { (_tags) in
         //   })
        //})
    }

}
