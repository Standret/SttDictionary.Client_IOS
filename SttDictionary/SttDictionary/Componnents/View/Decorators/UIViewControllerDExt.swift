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
}
