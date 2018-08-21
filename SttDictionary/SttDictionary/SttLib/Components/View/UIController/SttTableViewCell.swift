//
//  SttTableViewCell.swift
//  SttDictionary
//
//  Created by Standret on 19.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

class SttTableViewCell<T: SttViewInjector>: UITableViewCell, SttViewable {
    
    var presenter: T!
    
    private var firstStart = true
    func prepareBind() {
        presenter.injectView(delegate: self)
    }
}
