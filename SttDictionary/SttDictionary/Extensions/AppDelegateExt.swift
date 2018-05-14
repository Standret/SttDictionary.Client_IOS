//
//  AppDelegateExt.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import KeychainSwift
import SDWebImage
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes


extension AppDelegate {
    func configureStartOption()  {
        KeychainSwift().synchronizable = false
        var storyboardName = "Login"
        if KeychainSwift().get(Constants.tokenKey) != nil {
            storyboardName = "Main"
        }
        
        let stroyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewContrl = stroyboard.instantiateViewController(withIdentifier: "start")
        
        self.window?.rootViewController = viewContrl
        self.window?.makeKeyAndVisible()
    }
    
    func clearKeychainIfWillUnistall() {
        let freshInstall = !UserDefaults.standard.bool(forKey: "alreadyInstalled")
        if freshInstall {
            KeychainSwift().clear()
            UserDefaults.standard.set(true, forKey: "alreadyInstalled")
        }
    }
    
    func configureCacheOptions() {
        SDWebImageManager.shared().imageCache?.config.maxCacheAge = Constants.maxCacheAge
        SDWebImageManager.shared().imageCache?.config.maxCacheSize = UInt(Constants.maxImageCacheSize)
        
        let size = Double((SDWebImageManager.shared().imageCache?.getSize())!)
        print("image cache size: \(size / 1024.0 / 1024.0)mb\nused: \(size * 100.0 / Double(Constants.maxImageCacheSize))/100%")
    }
    
    func useAppCenter() {
        MSAppCenter.start("31daaa5b-c6d6-480b-9aae-a91dce6555b8", withServices:[
            MSAnalytics.self,
            MSCrashes.self
            ])
    }
}
