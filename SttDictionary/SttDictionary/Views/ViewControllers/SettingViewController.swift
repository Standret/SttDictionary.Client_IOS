//
//  SettingViewController.swift
//  SttDictionary
//
//  Created by Admin on 5/16/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

class SettingViewController: SttTableViewController<SettingPresenter>, SettingDelegate {
    
    @IBOutlet weak var syncCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}