//
//  SyncViewController.swift
//  SttDictionary
//
//  Created by Admin on 5/20/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import UIKit

class SyncViewController: SttViewController<SyncPresenter>, SyncDelegate {

    @IBOutlet weak var btnSync: UIButton!
    @IBOutlet weak var lblServerData: UILabel!
    @IBOutlet weak var lblLocalData: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBAction func syncClick(_ sender: Any) {
        presenter.sync.execute()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        btnSync.layer.cornerRadius = UIConstants.cornerRadius
        let indicator = btnSync.setIndicator()
        indicator.color = UIColor.white
        btnSync.setTitle("", for: .disabled)
        
        presenter.sync.addHandler(start: {
            self.btnSync.isEnabled = false
            indicator.startAnimating()
        }, end: {
            self.btnSync.isEnabled = true
            indicator.stopAnimating()
        })
    }
    
    func updateData(date: String, countLocal: Int, countServer: Int) {
        lblDate.text = date
        lblLocalData.text = String(countLocal)
        lblServerData.text = String(countServer)
    }
}
