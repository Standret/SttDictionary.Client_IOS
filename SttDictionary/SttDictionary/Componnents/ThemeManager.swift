//
//  ThemeManager.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/23/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import UIKit
import RxSwift

enum ModeState {
    case light, night
}

public class MainUILabel: UILabel { }
public class HighlightsUILabel: UILabel { }
public class MainUIView: UIView { }
public class MainUIButton: UIButton { }

class ThemeManager {
    
    private static var _modeState = UserDefaults.standard.bool(forKey: Constants.isNightThemeKey) ? ModeState.night : ModeState.light
    static var modeState: ModeState { return _modeState }
    
    private static var publisher = PublishSubject<ModeState>()
    static var observer: Observable<ModeState> { return publisher }
    
    class func prepare() {
        
        let mainLabel = MainUILabel.appearance()
        mainLabel.textColor = mainTextColor
        
        let highLightsLabel = HighlightsUILabel.appearance()
        highLightsLabel.textColor = highlightsComponent
        
        let mainView = MainUIView.appearance()
        mainView.backgroundColor = mainBackgroundColor
        
        let textField = UITextField.appearance()
        textField.keyboardAppearance = keyboardType
        textField.backgroundColor = secondaryBackgroundColor
        textField.textColor = mainTextColor
        
        let button = MainUIButton.appearance()
        button.setTitleColor(mainTextColor, for: .normal)
        button.tintColor = highlightsComponent
        
        publisher.onNext(modeState)
        
        let windows = UIApplication.shared.windows
        for window in windows {
            for view in window.subviews {
                view.removeFromSuperview()
                window.addSubview(view)
            }
        }
    }
    
    class func changeState(state: ModeState) {
        _modeState = state
        prepare()
        
        UserDefaults.standard.set(state == .night, forKey: Constants.isNightThemeKey)
    }
    
    static var mainTextColor: UIColor {
        var color: UIColor = UIColor.white
        switch modeState {
        case .light: color = UIColor(named: "_lightTextColor")!
        case .night: color = UIColor(named: "_nightTextColor")!
        }
        
        return color
    }
    
    static var mainBackgroundColor: UIColor {
        var color: UIColor = UIColor.white
        switch modeState {
        case .light: color = UIColor(named: "_lightBackground")!
        case .night: color = UIColor(named: "_nightBackground")!
        }
        
        return color
    }
    
    static var secondaryBackgroundColor: UIColor {
        var color: UIColor = UIColor.white
        switch modeState {
        case .light: color = UIColor(named: "_lightSecondaryBackground")!
        case .night: color = UIColor(named: "_nightSecondaryBackground")!
        }
        
        return color
    }
    
    static var navigationBarBackgroundColor: UIColor {
        var color: UIColor = UIColor.yellow
        switch modeState {
        case .light: color = UIColor(named: "main")!
        case .night: color = UIColor(named: "_nightBackground")!
        }
        
        return color
    }
    
    static var borderColor: UIColor {
        var color: UIColor = UIColor.yellow
        switch modeState {
        case .light: color = UIColor(named: "_lightBorder")!
        case .night: color = UIColor(named: "_nightBorder")!
        }
        
        return color
    }
    
    static var navigationBarShadowColor: UIColor {
        var color: UIColor = UIColor.yellow
        switch modeState {
        case .light: color = UIColor.black
        case .night: color = UIColor.white
        }
        
        return color
    }
    
    static var highlightsComponent: UIColor {
        var color: UIColor = UIColor.yellow
        switch modeState {
        case .light: color = UIColor(named: "cyan")!
        case .night: color = UIColor(named: "_nightHighlands")!
        }
        
        return color
    }
    
    static var keyboardType: UIKeyboardAppearance {
        var type: UIKeyboardAppearance = UIKeyboardAppearance.light
        switch modeState {
        case .light: type = .light
        case .night: type = .dark
        }
        
        return type
    }
}
