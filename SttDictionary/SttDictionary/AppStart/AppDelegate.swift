//
//  AppDelegate.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.useAppCenter()
        self.clearKeychainIfWillUnistall()
        
        ThemeManager.prepare()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        SttAppLifecycle.didEnterBackground()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        SttAppLifecycle.willEnterForeground()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        SttAppLifecycle.willTerminate()
    }
}

