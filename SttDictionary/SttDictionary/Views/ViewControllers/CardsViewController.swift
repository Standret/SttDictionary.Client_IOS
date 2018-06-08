//
//  CardsViewController.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/3/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import UIKit

class CardsViewController: SttViewController<CardsPresenter>, CardsDelegate {
    func showFinalPopup(message: String) {
        self.createAlerDialog(title: "Training is finished", message: message, buttonTitle: "Quiet") {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
  
    @IBOutlet weak var lblMain: UILabel!
    
    @IBOutlet weak var btnShow: UIButton!
    @IBOutlet weak var btnEasy: UIButton!
    @IBOutlet weak var btnHard: UIButton!
    @IBOutlet weak var btnForget: UIButton!
    
    @IBOutlet weak var vbackgroundTimer: UIView!
    @IBOutlet weak var cnstrProgress: NSLayoutConstraint!
    @IBAction func clickClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func showClick(_ sender: Any) {
        presenter.showAnswer()
        changeVisibility()
    }
    
    var i = 1
    @IBAction func seasyClick(_ sender: Any) {
        presenter.selectAnswer(type: .easy)
    }
    @IBAction func hardClick(_ sender: Any) {
        presenter.selectAnswer(type: .hard)
    }
    @IBAction func ForgetClick(_ sender: Any) {
        presenter.selectAnswer(type: .forget)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnShow.layer.cornerRadius = 10
        btnEasy.layer.cornerRadius = UIConstants.cornerRadius
        btnHard.layer.cornerRadius = UIConstants.cornerRadius
        btnForget.layer.cornerRadius = UIConstants.cornerRadius
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       // cnstrProgress.constant = vbackgroundTimer.bounds.width
    }

    private func changeVisibility() {
        btnEasy.isHidden = !btnEasy.isHidden
        btnHard.isHidden = !btnHard.isHidden
        btnForget.isHidden = !btnForget.isHidden
        btnShow.isHidden = !btnShow.isHidden
    }

    // MARK: - implementationm delegate
    
    func reloadWords(word: String, isNew: Bool) {
        lblMain.text = word
        if isNew {
            cnstrProgress.constant = vbackgroundTimer.bounds.width - (vbackgroundTimer.bounds.width / CGFloat(presenter.words.count) * CGFloat(presenter.current))
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
            }
            changeVisibility()
        }
    }

}
