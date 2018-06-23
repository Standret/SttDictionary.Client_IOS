//
//  SttViewable.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/22/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

protocol SttViewable: class { }
typealias SttViewContolable = SttViewableNavigation & SttViewableListener

protocol SttViewableNavigation: SttViewable {
    func navigate(to: String, withParametr: Any?, callback: ((Any) -> Void)?)
    func navigate<T>(storyboard: Storyboard, to _: T.Type, typeNavigation: TypeNavigation, withParametr: Any?, callback: ((Any) -> Void)?)
    func loadStoryboard(storyboard: Storyboard)
    
    func close()
    func close(parametr: Any)
}

protocol SttViewableListener: SttViewable {
    func sendMessage(title: String, message: String?)
    func sendError(error: SttBaseError)
}

protocol SttViewInjector {
    func injectView(delegate: SttViewable)
    func prepare(parametr: Any?)
    init()
}
