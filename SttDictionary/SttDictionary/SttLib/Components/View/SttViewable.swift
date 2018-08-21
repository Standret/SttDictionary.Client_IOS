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
typealias SttViewControlable = SttViewableNavigation & SttViewableListener

protocol SttViewableNavigation: SttViewable {
    func navigate(to: String, withParametr: Any?, callback: ((Any) -> Void)?)
    func navigate<T>(storyboard: SttStoryboardType, to _: T.Type, typeNavigation: TypeNavigation, withParametr: Any?, callback: ((Any) -> Void)?)
    func loadStoryboard(storyboard: SttStoryboardType)
    
    func close(animated: Bool)
    func close(parametr: Any, animated: Bool)
}

extension SttViewableNavigation {
    func close(animated: Bool = true) {
        self.close(animated: animated)
    }
    func close(parametr: Any, animated: Bool = true) {
        self.close(parametr: parametr, animated: animated)
    }
}

protocol SttViewableListener: SttViewable {
    func sendMessage(title: String, message: String?)
    func sendError(error: SttBaseErrorType)
}

protocol SttViewInjector {
    func injectView(delegate: SttViewable)
    func prepare(parametr: Any?)
    init()
}
