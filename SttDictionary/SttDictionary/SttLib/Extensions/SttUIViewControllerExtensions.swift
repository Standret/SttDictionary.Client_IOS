//
//  UIViewControllerDExt.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import UIKit

extension UIViewController {
    
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
    
    func createAlerDialog(title: String?, message: String, buttonTitle: String? = nil, handlerOk: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttonTitle ?? "Ok", style: .cancel, handler: { (action) in
            self.resignFirstResponder()
            handlerOk?()
        }))
        if let popover = alertController.popoverPresentationController {
            popover.sourceView = self.view
            popover.permittedArrowDirections = .up
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func createDecisionAlerDialog(title: String?, message: String, buttonTrueTitle: String? = nil, buttonFalseTitle: String? = nil, handlerOk: (() -> Void)? = nil, handlerFalse: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttonTrueTitle ?? "Yes", style: .cancel, handler: { (action) in
            handlerOk?()
        }))
        alertController.addAction(UIAlertAction(title: buttonFalseTitle ?? "Cancel", style: .default, handler: { (action) in
            self.resignFirstResponder()
            handlerFalse?()
        }))
        if let popover = alertController.popoverPresentationController {
            popover.sourceView = self.view
            popover.permittedArrowDirections = .up
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}
