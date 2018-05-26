//
//  SttViewController.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import UIKit

enum TypeNavigation {
    case push
    case modality
}

protocol Viewable: class {
    func sendMessage(title: String, message: String?)
    func sendError(error: BaseError)
    func close()
}

protocol ViewInjector {
    func injectView(delegate: Viewable)
    init()
}

class SttViewController<T: ViewInjector>: UIViewController, Viewable, KeyboardNotificationDelegate {
    
    var presenter: T!
    var keyboardNotification: KeyboardNotification!
    var scrollAmount: CGFloat = 0
    var scrollAmountGeneral: CGFloat = 0
    var moveViewUp: Bool = false
    
    var heightScreen: CGFloat { return UIScreen.main.bounds.height }
    var widthScreen: CGFloat { return UIScreen.main.bounds.width }
    var hideNavigationBar = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardNotification = KeyboardNotification()
        keyboardNotification.callIfKeyboardIsShow = true
        keyboardNotification.delegate = self
        
        presenter = T()//.init(delegate: self)
        presenter.injectView(delegate: self)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleClick(_:))))
        
        _ = GlobalObserver.observableStatusApplication.subscribe(onNext: { (status) in
            if status == ApplicationStatus.EnterBackgound {
                self.view.endEditing(true)
                self.navigationController?.navigationBar.endEditing(true)
            }
        })
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(hideNavigationBar, animated: true)
    }
    
    func sendError(error: BaseError) {
        let serror = error.getMessage()
        self.createAlerDialog(title: serror.0, message: serror.1)
    }
    func sendMessage(title: String, message: String?) {
        self.createAlerDialog(title: title, message: message ?? "empty")
    }
    
    func close() {
        navigationController?.popViewController(animated: true)
    }
}

