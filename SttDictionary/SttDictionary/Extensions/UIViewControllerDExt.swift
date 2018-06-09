//
//  UIViewControllerDExt.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import UIKit

extension UIViewController {
    func configurationNavigationBar () {
        navigationController?.navigationBar.tintColor = UIColor(named: "TitleNavBarForegoundColor")
        navigationController?.navigationBar.barTintColor = UIColor(named: "TitleNavBarBackgroundColor")
        navigationController?.navigationBar.isTranslucent = true
    }
    
    var isModal: Bool {
        if let index = navigationController?.viewControllers.index(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController  {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
}
