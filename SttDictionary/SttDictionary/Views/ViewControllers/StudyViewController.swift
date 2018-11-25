//
//  StudyViewController.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/2/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import UIKit
import AVFoundation

class StudyViewController: SttViewController<StudyPresenter>, StudyDelegate {

    @IBOutlet weak var lblStatistics: UILabel!
    @IBOutlet weak var mainView: UIView!
    var indView: UIView!
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func clickOnOriginalCard(_ sender: Any) {
        presenter.onCLickOriginalCard()
    }
    @IBAction func clicOnTranslateCard(_ sender: Any) {
        presenter.onClickTranslateCard()
    }
    
    var player: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.layer.cornerRadius = UIConstants.cornerRadius
    }
    
    private var firstStart = true
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if firstStart {
            firstStart = false
            
            indView = UIView(frame: self.view.frame)
            indView.backgroundColor = UIColor(named: "maskBackground")!
            let indicator = indView.setIndicator(style: UIActivityIndicatorViewStyle.white, color: UIColor.white)
            indicator.startAnimating()
            
            presenter.reload.addHandler(start: {
                self.view.addSubview(self.indView)
            }, end: nil)
        }
    
        presenter.reload.execute()
    }
    
    // MARK: -- implementation delegate
    
    func reloadStatus() {
        indView.removeFromSuperview()
        lblStatistics.text = "Today original cards: \(presenter.newWords.count) | \(presenter.repeatWords.count)\ntranslation cards: \(presenter.newTranslationWords.count) | \(presenter.repeatTranslationWords.count)"
    }
}
