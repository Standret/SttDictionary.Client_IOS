//
//  KeyboardNotification.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

protocol KeyboardNotificationDelegate {
    func keyboardWillShow(height: CGFloat)
    func keyboardWillHide(height: CGFloat)
}

class KeyboardNotification {
    
    var isAnimation: Bool = false
    var callIfKeyboardIsShow: Bool = false
    
    var delegate: KeyboardNotificationDelegate!
    
    var bounds: CGRect {
        if let frame: NSValue = notificationObject?.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            return frame.cgRectValue
        }
        return CGRect()
    }
    var heightKeyboard: CGFloat {
        return bounds.height
    }
    
    private var isKeyboardShow: Bool = true
    private var notificationObject: Notification!
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification?) {
        notificationObject = notification
        if callIfKeyboardIsShow || !isKeyboardShow {
            delegate?.keyboardWillShow(height: heightKeyboard)
        }
        isKeyboardShow = true
    }
    @objc private func keyboardWillHide(_ notification: Notification?) {
        notificationObject = notification
        delegate?.keyboardWillHide(height: heightKeyboard)
        isKeyboardShow = false
    }
}
