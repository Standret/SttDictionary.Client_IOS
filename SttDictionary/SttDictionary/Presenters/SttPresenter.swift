//
//  SttPresenter.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

class SttPresenter<TDelegate> : Defaultable {

    var delegate: TDelegate!
    
    required init() { }
    func injectView(delegate: Viewable) {
        self.delegate = delegate as! TDelegate
        
        presenterCreating()
    }
    
    func presenterCreating() { }
}
