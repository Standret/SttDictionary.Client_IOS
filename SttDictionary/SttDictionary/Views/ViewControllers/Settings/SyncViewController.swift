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
    @IBOutlet weak var btnSent: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblWords: UILabel!
    @IBOutlet weak var lblTags: UILabel!
    @IBOutlet weak var lblStat: UILabel!
    @IBOutlet weak var lblAnswer: UILabel!
    
    var indicatorInNavBar: UIActivityIndicatorView!
    
    @IBAction func syncClick(_ sender: Any) {
        presenter.sync.execute()
    }
    @IBAction func sentClick(_ sender: Any) {
        presenter.send.execute()
    }
    @IBAction func updateClick(_ sender: Any) {
        presenter.update.execute()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        btnSync.layer.cornerRadius = UIConstants.cornerRadius
        btnSent.layer.cornerRadius = UIConstants.cornerRadius
        btnUpdate.layer.cornerRadius = UIConstants.cornerRadius
        
        let data = SttDefaultComponnents.createBarButtonLoader()
        indicatorInNavBar = data.1
        indicatorInNavBar.color = UIColor.white
        indicatorInNavBar.startAnimating()
        navigationItem.setRightBarButton(data.0, animated: true)
        
        presenter.sync.useIndicator(button: btnSync, style: .white)
        presenter.send.useIndicator(button: btnSent, style: .white)
        presenter.update.useIndicator(button: btnUpdate, style: .white)
    }
    
    // MARK: -- SyncDelegate
    
    func updateData(date: String, count: CountViewModel) {
        lblDate.text = date
        lblWords.text = "\(count.serverAll.countOfWords) | \(count.localAll.countOfWords) -- \(count.localNotSynced.countOfWords) | \(count.localNewNotSynced.countOfWords)"
        lblTags.text = "\(count.serverAll.countOfTags) | \(count.localAll.countOfTags) -- \(count.localNotSynced.countOfTags) | \(count.localNewNotSynced.countOfTags)"
        lblAnswer.text = "\(count.serverAll.countOfAnswers) | \(count.localAll.countOfAnswers) -- \(count.localNotSynced.countOfAnswers) | \(count.localNewNotSynced.countOfAnswers)"
        lblStat.text = "\(count.serverAll.countOfStatistics) | \(count.localAll.countOfStatistics) -- \(count.localNotSynced.countOfStatistics) | \(count.localNewNotSynced.countOfStatistics)"
    }
    
    func loadCompleted() {
        indicatorInNavBar.stopAnimating()
    }
}
