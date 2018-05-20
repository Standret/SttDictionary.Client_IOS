//
//  SttTableViewController.swift
//  SttDictionary
//
//  Created by Admin on 5/16/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

class SttTableViewController<T: ViewInjector>: UITableViewController, Viewable, KeyboardNotificationDelegate {
    
    func sendError(error: String) {
        fatalError(Constants.noImplementException)
    }
    
    
    func navigate(storyboardName: String, type: TypeNavigation = .modality, animated: Bool = true) {
        let stroyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewContrl = stroyboard.instantiateViewController(withIdentifier: "start")
        switch type {
        case .modality:
            present(viewContrl, animated: animated, completion: nil)
        case .push:
            navigationController?.pushViewController(viewContrl, animated: animated)
        }
    }
    
    func navigate(storyboardName: String, id: String, type: TypeNavigation, animated: Bool = true)  {
        let stroyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewContrl = stroyboard.instantiateViewController(withIdentifier: id)
        switch type {
        case .modality:
            present(viewContrl, animated: animated, completion: nil)
        case .push:
            navigationController?.pushViewController(viewContrl, animated: animated)
        }
    }
    
    var presenter: T!
    var keyboardNotification: KeyboardNotification!
    var scrollAmount: CGFloat = 0
    var scrollAmountGeneral: CGFloat = 0
    var moveViewUp: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardNotification = KeyboardNotification()
        keyboardNotification.callIfKeyboardIsShow = true
        keyboardNotification.delegate = self
        
        presenter = T()
        presenter.injectView(delegate: self)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleClick(_:))))
    }
    
    @objc
    func handleClick(_ : UITapGestureRecognizer?) {
        view.endEditing(true)
    }
    
    func keyboardWillShow(height: CGFloat) {
        if view != nil {
            scrollAmount = height - scrollAmountGeneral
            scrollAmountGeneral = height
            
            moveViewUp = true
            scrollTheView(move: moveViewUp)
        }
    }
    func keyboardWillHide(height: CGFloat) {
        view.endEditing(true)
        if moveViewUp {
            scrollTheView(move: false)
        }
    }
    
    func scrollTheView(move: Bool) {
        // view.layoutIfNeeded()
        var frame = view.frame
        if move {
            frame.size.height -= scrollAmount
        }
        else {
            frame.size.height += scrollAmountGeneral
            scrollAmountGeneral = 0
            scrollAmount = 0
        }
        view.frame = frame
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}

