//
//  AppereanceViewController.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/23/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import UIKit

class AppereanceViewController: UIViewController {

    @IBOutlet weak var swtchNightMode: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        swtchNightMode.addTarget(self, action: #selector(onSwitcherChange(_:)), for: .valueChanged)
        swtchNightMode.isOn = ThemeManager.modeState == .night
    }
    
    @objc private func onSwitcherChange(_ sender: UISwitch) {
        ThemeManager.changeState(state: ThemeManager.modeState == .light ? .night : .light)
    }
}
