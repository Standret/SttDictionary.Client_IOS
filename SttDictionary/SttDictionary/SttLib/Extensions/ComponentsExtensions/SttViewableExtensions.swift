//
//  SttViewable.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/22/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

extension SttViewableNavigation {
    func navigate(to: String, withParametr: Any? = nil, callback: ((Any) -> Void)? = nil) {
        self.navigate(to: to, withParametr: withParametr, callback: callback)
    }
    func navigate<T>(storyboard: Storyboard, to _: T.Type, typeNavigation: TypeNavigation = .push, withParametr: Any? = nil, callback: ((Any) -> Void)? = nil) {
        self.navigate(storyboard: storyboard, to: T.self, typeNavigation: typeNavigation, withParametr: withParametr, callback: callback)
    }
}
