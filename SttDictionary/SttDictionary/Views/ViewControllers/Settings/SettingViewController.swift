//
//  SettingViewController.swift
//  SttDictionary
//
//  Created by Admin on 5/16/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

class SettingViewController: UITableViewController {
    
    @IBOutlet weak var syncCell: UITableViewCell!
    @IBOutlet weak var newWordCell: UITableViewCell!
    @IBOutlet weak var newTag: UITableViewCell!
    @IBOutlet weak var SM2settingCell: UITableViewCell!
    @IBOutlet weak var statisticsCell: UITableViewCell!
    @IBOutlet weak var appereanceCell: UITableViewCell!
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ThemeManager.observer.subscribe(onNext: { _ in self.prepateTheme() })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        prepateTheme()
    }
    
    func prepateTheme() {
        self.navigationController?.shadowColor = ThemeManager.navigationBarShadowColor.cgColor
        navigationController?.navigationBar.barTintColor = ThemeManager.navigationBarBackgroundColor
        
        tableView.backgroundColor = ThemeManager.mainBackgroundColor
        tableView.separatorColor = ThemeManager.borderColor
        
        let cellArray = [syncCell, newWordCell, newTag,  SM2settingCell, statisticsCell, appereanceCell]
        
        for item in cellArray {
            item!.backgroundColor = ThemeManager.secondaryBackgroundColor
            //item!.textLabel?.textColor = ThemeManager.mainTextColor
        }
    }
}
