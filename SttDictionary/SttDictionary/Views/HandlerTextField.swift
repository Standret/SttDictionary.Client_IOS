//
//  TextField.swift
//  SttDictionary
//
//  Created by Admin on 5/19/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

class HandlerTextField: NSObject, UITextFieldDelegate {
    
    // private property
    private var handlerReturnKey: ((UITextField) -> Void)?
    
    // method for add target
    func addTargetReturnKey(handler: @escaping (UITextField) -> Void) {
        handlerReturnKey = handler
    }
    
    // implements protocol
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let handler = handlerReturnKey {
            handler(textField)
        }
        return true
    }
}
