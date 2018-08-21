//
//  SttUITextField.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/23/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import UIKit

extension UITextField {
    func setPlaceholderColor(color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "nani", attributes: [NSAttributedStringKey.foregroundColor: color])
    }
}
