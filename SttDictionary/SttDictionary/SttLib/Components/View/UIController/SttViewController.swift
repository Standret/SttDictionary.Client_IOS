//
//  SttViewController.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/22/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

class SttBaseViewController: UIViewController, SttKeyboardNotificationDelegate {
    
    fileprivate var parametr: Any?
    fileprivate var callback: ((Any) -> Void)?
    
    fileprivate var keyboardNotification: SttKeyboardNotification!
    fileprivate var scrollAmount: CGFloat = 0
    fileprivate var scrollAmountGeneral: CGFloat = 0
    var moveViewUp: Bool = false
    var style = UIStatusBarStyle.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardNotification = SttKeyboardNotification()
        keyboardNotification.callIfKeyboardIsShow = true
        keyboardNotification.delegate = self
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
        if moveViewUp {
            scrollTheView(move: false)
        }
        view.endEditing(true)
    }
    
    func scrollTheView(move: Bool) {
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
    
    func insertParametr(parametr: Any?) {
        self.parametr = parametr
    }
}

class SttViewController<T: SttViewInjector>: SttBaseViewController, SttViewContolable {
    
    var presenter: T!
    
    var heightScreen: CGFloat { return UIScreen.main.bounds.height }
    var widthScreen: CGFloat { return UIScreen.main.bounds.width }
    
    var useErrorLabel = true
    var hideNavigationBar = false
    var hideTabBar = false
    
    
    private var viewError: SttErrorLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewError = SttErrorLabel()
        viewError.backgroundColor = UIColor(red:0.98, green:0.26, blue:0.26, alpha:1)
        view.addSubview(viewError)
        viewError.delegate = self
        
        presenter = T()
        presenter.injectView(delegate: self)
        presenter.prepare(parametr: parametr)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleClick(_:))))
        
        _ = SttGlobalObserver.observableStatusApplication.subscribe(onNext: { (status) in
            if status == .EnterBackgound {
                self.view.endEditing(true)
                self.navigationController?.navigationBar.endEditing(true)
            }
        })
    }
    
    @objc
    func handleClick(_ : UITapGestureRecognizer?) {
        view.endEditing(true)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = style
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.setNeedsStatusBarAppearanceUpdate()
        }
        navigationController?.setNavigationBarHidden(hideNavigationBar, animated: true)
        navigationController?.navigationController?.navigationBar.isHidden = hideNavigationBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        keyboardNotification.addObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardNotification.removeObserver()
        navigationController?.navigationController?.navigationBar.isHidden = false
    }
    
    func sendError(error: SttBaseErrorType) {
        let serror = error.getMessage()
        if useErrorLabel {
            viewError.showError(text: serror.0, detailMessage: serror.1)
        }
        else {
            self.createAlerDialog(title: serror.0, message: serror.1)
        }
    }
    func sendMessage(title: String, message: String?) {
        self.createAlerDialog(title: title, message: message!)
    }
    
    func close() {
        if self.isModal {
            dismiss(animated: true, completion: nil)
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    func close(parametr: Any) {
        callback?(parametr)
        close()
    }
    
    func navigate<T>(storyboard: SttStoryboardType, to _: T.Type, typeNavigation: TypeNavigation, withParametr: Any?, callback: ((Any) -> Void)?)  {
        
        let bundle = Bundle(for: type(of: self))
        let _nibName = "\(type(of: T.self))".components(separatedBy: ".").first!
        let nibName = String(_nibName[..<(_nibName.index(_nibName.endIndex, offsetBy: -9))])
        
        let stroyboard = UIStoryboard(name: storyboard.getName(), bundle: bundle)
        let vc = stroyboard.instantiateViewController(withIdentifier: nibName) as! SttBaseViewController
        vc.parametr = withParametr
        vc.callback = callback
        switch typeNavigation {
        case .modality:
            present(vc, animated: true, completion: nil)
        case .push:
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    func loadStoryboard(storyboard: SttStoryboardType) {
        let stroyboard = UIStoryboard(name: storyboard.getName(), bundle: nil)
        let vc = stroyboard.instantiateViewController(withIdentifier: "start")
        present(vc, animated: true, completion: nil)
    }
    
    private var navigateData: (String, Any?, ((Any) -> Void)?)?
    func navigate(to: String, withParametr: Any?, callback: ((Any) -> Void)?) {
        navigateData = (to, withParametr, callback)
        performSegue(withIdentifier: to, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let  navDatra = navigateData {
            if segue.identifier == navDatra.0 {
                let previewC = segue.destination as! SttBaseViewController
                previewC.parametr = navigateData?.1
                previewC.callback = navigateData?.2
                navigateData = nil
            }
        }
    }
}
