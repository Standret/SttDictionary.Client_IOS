//
//  SttUISegmentControlExtensions.swift
//  SttLib
//
//  Created by Standret on 12.06.18.
//  Copyright © 2018 com.standret.SttLib All rights reserved.
//

import Foundation
import UIKit

extension UISegmentedControl {
    func removeBorders() {
        self.setBackgroundImage(imageWithColor(color: UIColor.clear), for: .normal, barMetrics: .default)
        self.setBackgroundImage(imageWithColor(color:  UIColor.clear), for: .selected, barMetrics: .default)
        self.setDividerImage(imageWithColor(color:  UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}
