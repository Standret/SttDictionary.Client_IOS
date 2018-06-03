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
    func close(parametr: Any) {
        
    }
    func navigate(to: String, withParametr: Any, callback: ((Any) -> Void)?) {
        
    }
    func sendMessage(title: String, message: String?) {
        
    }
    func sendError(error: BaseError) {
        
    }
    
    
    var dataContext: T!
    
    private var firstStart = true
    func prepareBind() {
        dataContext.injectView(delegate: self)
    }
    
    func sendError(title: String?, message: String) {
        fatalError(Constants.noImplementException)
    }
    
    func close() {
        fatalError(Constants.noImplementException)
    }
}
