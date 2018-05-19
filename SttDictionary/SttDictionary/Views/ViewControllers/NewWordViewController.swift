//
//  NewWordViewController.swift
//  SttDictionary
//
//  Created by Admin on 5/16/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

class NewWordViewController: SttViewController<NewWordPresenter>, NewWordDelegate {
    
    @IBOutlet weak var btnAddTranslation: UIButton!
    @IBOutlet weak var tfWord: UITextField!
    @IBOutlet weak var tfMainTranslation: UITextField!
    
    @IBAction func closeClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        btnAddTranslation.layer.cornerRadius = 5
        btnAddTranslation.clipsToBounds = true
        
        tfWord.layer.borderWidth = 5
        tfWord.layer.borderColor = UIColor.red.cgColor
      //  tfWord.setBorder(color: UIColor(named: "border")!, size: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tfWord.setBorder(color: UIColor(named: "border")!, size: 1)
        tfMainTranslation.setBorder(color: UIColor(named: "border")!, size: 1)
        
        btnAddTranslation.layer.cornerRadius = 5
        btnAddTranslation.clipsToBounds = true
        btnAddTranslation.tintColor = UIColor.white
    }
    
}
