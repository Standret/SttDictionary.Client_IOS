//
//  SttDefaultComponents.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/7/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

class SttDefaultComponnents {
    class func createBarButtonLoader() -> (UIBarButtonItem, UIActivityIndicatorView) {
        let statusUpdatedIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        statusUpdatedIndicator.startAnimating()
        statusUpdatedIndicator.activityIndicatorViewStyle = .gray
        statusUpdatedIndicator.hidesWhenStopped = true
        let indicatorButton = UIBarButtonItem(customView: statusUpdatedIndicator)
        indicatorButton.isEnabled = false
        
        return (indicatorButton, statusUpdatedIndicator)
    }
}
