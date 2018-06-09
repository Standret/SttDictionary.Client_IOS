//
//  StudyViewController.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/2/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import UIKit

class StudyViewController: SttViewController<StudyPresenter>, StudyDelegate {

    @IBOutlet weak var lblStatistics: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func clickOnOriginalCard(_ sender: Any) {
        presenter.onCLickOriginalCard()
    }
    @IBAction func clicOnTranslateCard(_ sender: Any) {
        presenter.onClickTranslateCard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.layer.cornerRadius = UIConstants.cornerRadius
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.reloadData()
    }
    
    // MARK: -- implementation delegate
    
    func reloadStatus() {
        lblStatistics.text = "Today original cards: \(presenter.newWords.count) | \(presenter.repeatWords.count)\ntranslation cards: \(presenter.newTranslationWords.count) | \(presenter.repeatTranslationWords.count)"
    }
}
