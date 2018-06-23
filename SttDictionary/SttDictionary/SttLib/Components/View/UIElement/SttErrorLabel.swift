//
//  SttErrorLabel.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/22/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

class SttErrorLabel: UIView {
    private var errorLabel: UILabel!
    private var topContraint: NSLayoutConstraint!
    private var detailMessage: String?
    
    weak var delegate: UIViewController! {
        didSet {
            injectConponnent()
        }
    }
    var heightErrorLabel: CGFloat = 40
    var textColor: UIColor? {
        didSet {
            errorLabel.textColor = textColor
        }
    }
    var textFont: UIFont? {
        didSet {
            errorLabel.font = textFont
        }
    }
    
    func showError(text: String, detailMessage: String?) {
        self.detailMessage = detailMessage
        errorLabel.text = text
        topContraint.constant = 0
        UIView.animate(withDuration: 0.5, animations: { [weak self] in self?.delegate.view?.layoutIfNeeded() })
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] (timer) in
            timer.invalidate()
            self?.topContraint.constant = self!.heightErrorLabel
            UIView.animate(withDuration: 0.5, animations: { [weak self] in self?.delegate.view?.layoutIfNeeded() })
        }
    }
    
    @objc func onClick(_ sender: Any) {
        if let message = detailMessage {
            delegate.createAlerDialog(title: errorLabel.text, message: message)
        }
    }
    
    private func injectConponnent() {
        translatesAutoresizingMaskIntoConstraints = false
        delegate.view.addSubview(self)
        topContraint = NSLayoutConstraint(item: delegate.view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 40)
        delegate.view.addConstraints([
            topContraint,
            NSLayoutConstraint(item: delegate.view, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: delegate.view, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
            ])
        self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: heightErrorLabel))
        
        errorLabel = UILabel()
        errorLabel.textColor = UIColor.white
        errorLabel.font = UIFont.systemFont(ofSize: 14)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textAlignment = .center
        
        self.addSubview(errorLabel)
        self.addConstraints([
            NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: errorLabel, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: errorLabel, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: errorLabel, attribute: NSLayoutAttribute.left, multiplier: 1, constant: -15),
            NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: errorLabel, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 15)
            ])
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClick(_:))))
    }
}
