//
//  CustomDialog.swift
//  SttDictionary
//
//  Created by Standret on 5/20/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
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
}
