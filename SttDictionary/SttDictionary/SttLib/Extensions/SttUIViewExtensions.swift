//
//  SttUIViewExtensions.swift
//  SttDictionary
//
//  Created by Standret on 22.06.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func createCircle(dominateWidth: Bool = true, clipToBounds: Bool = true) {
        if dominateWidth {
            layer.cornerRadius = bounds.width / 2
        }
        else {
            layer.cornerRadius = bounds.height / 2
        }
        self.clipsToBounds = clipToBounds
    }
    
    func setBorder(color: UIColor, size: Float) {
        self.clipsToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = CGFloat(size)
    }
    
    func setShadow(color: UIColor, size: CGSize = CGSize.zero, opacity: Float = 0.2, radius: Float = 1) {
        layer.shadowOffset = size
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
        layer.shadowRadius = CGFloat(radius)
    }
    
    func setIndicator(style: UIActivityIndicatorViewStyle = .gray, color: UIColor = UIColor.gray) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = style
        indicator.color = color
        
        indicator.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        self.addSubview(indicator)
        
        return indicator
    }
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        } else {
            return self.topAnchor
        }
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.leftAnchor
        }else {
            return self.leftAnchor
        }
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.rightAnchor
        }else {
            return self.rightAnchor
        }
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        } else {
            return self.bottomAnchor
        }
    }
}
