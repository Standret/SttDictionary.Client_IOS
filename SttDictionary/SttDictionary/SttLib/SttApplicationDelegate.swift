//
//  SttApplicationDelegate.swift
//  SttDictionary
//
//  Created by Standret on 22.06.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

//@UIApplicationMain
public class SttApplicationDelegate: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?

    public func applicationDidEnterBackground(_ application: UIApplication) {
        SttGlobalObserver.applicationStatusChanged(status: .EnterBackgound)
    }
    
    public func applicationWillEnterForeground(_ application: UIApplication) {
        SttGlobalObserver.applicationStatusChanged(status: .EnterForeground)
    }
}
