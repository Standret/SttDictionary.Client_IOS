//
//  TextField.swift
//  SttDictionary
//
//  Created by Standret on 5/19/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

import Foundation
import UIKit

enum TypeActionTextField {
    case shouldReturn
    case didEndEditing
}

class SttHandlerTextField: NSObject, UITextFieldDelegate {
    
    // private property
    private var handlers = [TypeActionTextField:(UITextField) -> Void]()
    
    // method for add target
    func addTargetReturnKey(type:TypeActionTextField, handler: @escaping (UITextField) -> Void) {
        handlers[type] = handler
    }
    
    // implements protocol
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let handler = handlers[.shouldReturn]  {
            handler(textField)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let handler = handlers[.didEndEditing]  {
            handler(textField)
        }
    }
}
