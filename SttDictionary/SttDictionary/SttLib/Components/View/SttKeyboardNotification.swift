//
//  SttKeyboardNotification.swift
//  SttDictionary
//
//  Created by Standret on 22.06.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

public protocol SttKeyboardNotificationDelegate: class {
    func keyboardWillShow(height: CGFloat)
    func keyboardWillHide(height: CGFloat)
}

public class SttKeyboardNotification {
    
    public var isAnimation: Bool = false
    public var callIfKeyboardIsShow: Bool = false
    
    public weak var delegate: SttKeyboardNotificationDelegate!
    
    public var bounds: CGRect {
        if let frame: NSValue = notificationObject?.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            return frame.cgRectValue
        }
        return CGRect()
    }
    public var heightKeyboard: CGFloat {
        return bounds.height
    }
    
    private var isKeyboardShow: Bool = true
    private var notificationObject: Notification!
    
    public func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    public func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

    
    @objc private func keyboardWillShow(_ notification: Notification?) {
        print("WillShow")
        notificationObject = notification
        if callIfKeyboardIsShow || !isKeyboardShow {
            delegate?.keyboardWillShow(height: heightKeyboard)
        }
        isKeyboardShow = true
    }
    @objc private func keyboardWillHide(_ notification: Notification?) {
        print("WillHide")
        notificationObject = notification
        delegate?.keyboardWillHide(height: heightKeyboard)
        isKeyboardShow = false
    }
}
