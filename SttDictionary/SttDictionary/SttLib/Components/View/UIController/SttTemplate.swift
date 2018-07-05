//
//  SttTemplate.swift
//  YURT
//
//  Created by Standret on 2/10/18.
//  Copyright © 2018 standret. All rights reserved.
//

import UIKit

class SttTemplate: UIView {
    
    var view: UIView!
    func loadNib() {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
    }
}
