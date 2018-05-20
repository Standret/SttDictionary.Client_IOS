//
//  SttTableViewCell.swift
//  SttDictionary
//
//  Created by Standret on 19.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

class SttTableViewCell<T: ViewInjector>: UITableViewCell, Viewable {
    var dataContext: T!
    
    private var firstStart = true
    func prepareBind() {
        dataContext.injectView(delegate: self)
    }
    
    func sendError(error: String) {
        fatalError(Constants.noImplementException)
    }
}
