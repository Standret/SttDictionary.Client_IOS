//
//  SttNavigationControllerExtensions.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/23/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    var shadowColor: CGColor? {
        get { return self.navigationBar.layer.shadowColor }
        set(value) {
            self.navigationBar.layer.masksToBounds = false
            self.navigationBar.layer.shadowColor = value
            self.navigationBar.layer.shadowOpacity = 0.6
            self.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0.5)
            self.navigationBar.layer.shadowRadius = 0.5
        }
    }
}
