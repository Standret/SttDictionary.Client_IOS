//
//  SttHandlerTextView.swift
//  YURT
//
//  Created by Standret on 27.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit

enum TypeActionTextView {
    case didBeginEditing, didEndEditing
    case editing
}

class SttHandlerTextView: NSObject, UITextViewDelegate {
    
    // private property
    private var handlers = [TypeActionTextView:(UITextView) -> Void]()
    
    // method for add target
    
    func addTarget<T: UIViewController>(type: TypeActionTextView, delegate: T, handler: @escaping (T, UITextView) -> Void, textField: UITextView) {
        handlers[type] = { [weak delegate] tf in
            if let _delegate = delegate {
                handler(_delegate, tf)
            }
        }
    }
    
    // implements protocol
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let handler = handlers[.didBeginEditing]  {
            handler(textView)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let handler = handlers[.didEndEditing]  {
            handler(textView)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let handler = handlers[.editing]  {
            handler(textView)
        }
    }
}
