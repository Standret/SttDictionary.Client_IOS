//
//  SttCollectionCell.swift
//  SttDictionary
//
//  Created by Standret on 19.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

class SttCollectionViewCell<T: ViewInjector>: UICollectionViewCell, Viewable {
    var dataContext: T!
    
    func sendError(error: String) {
        fatalError(Constants.noImplementException)
    }
    
    private var firstStart = true
    func prepareBind() {
        dataContext.injectView(delegate: self)
    }
}
