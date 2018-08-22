//
//  CardsViewController.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/3/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import UIKit
import AVFoundation

class CardsViewController: SttViewController<CardsPresenter>, CardsDelegate {

    func showFinalPopup(message: String) {
        self.createAlerDialog(title: "Training is finished", message: message, buttonTitle: "Quiet") {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    let synthesizer = AVSpeechSynthesizer()
    var player: AVPlayer!

    @IBOutlet weak var lblMain: UILabel!
    @IBOutlet weak var lblExample: UILabel!
    
    @IBOutlet weak var btnShow: UIButton!
    @IBOutlet weak var btnEasy: UIButton!
    @IBOutlet weak var btnHard: UIButton!
    @IBOutlet weak var btnForget: UIButton!
    @IBOutlet weak var btnSound: UIButton!
    
    @IBOutlet weak var vbackgroundTimer: UIView!
    @IBOutlet weak var cnstrProgress: NSLayoutConstraint!
    @IBAction func clickClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showClick(_ sender: Any) {
        presenter.showAnswer()
        changeVisibility()
    }
    
    static var isVolumeEnabled = true
    @IBAction func onSoundClick(_ sender: Any) {
        CardsViewController.isVolumeEnabled = !CardsViewController.isVolumeEnabled
        
        if CardsViewController.isVolumeEnabled {
            btnSound.setImage(UIImage(named: "hornOn"), for: .normal)
            btnSound.tintColor = UIColor(named: "main")
        }
        else {
            btnSound.setImage(UIImage(named: "hornOff"), for: .normal)
            btnSound.tintColor = UIColor.lightGray
        }
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

        style = ThemeManager.modeState == .light ? .default : .lightContent
        btnShow.layer.cornerRadius = 10
        btnEasy.layer.cornerRadius = UIConstants.cornerRadius
        btnHard.layer.cornerRadius = UIConstants.cornerRadius
        btnForget.layer.cornerRadius = UIConstants.cornerRadius
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try! AVAudioSession.sharedInstance().setActive(true)
        
        lblMain.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickRepeatVoice(_:))))
        lblMain.isUserInteractionEnabled = true
    }
    
    private func changeVisibility() {
        btnEasy.isHidden = !btnEasy.isHidden
        btnHard.isHidden = !btnHard.isHidden
        btnForget.isHidden = !btnForget.isHidden
        btnShow.isHidden = !btnShow.isHidden
    }
    
    @objc private func onClickRepeatVoice(_ sender: Any) {
        if let data = voiceData {
            if data.2 {
                if let url = data.1 {
                    playTrack(url: url)
                }
                else {
                    syntheseVoice(text: data.0)
                }
            }
        }
    }
    
    private var voiceData: (String, String?, Bool)?
    private func syntheseVoice(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        synthesizer.speak(utterance)
    }
    private func playTrack(url: String) {
        let url = URL(string: url)!
        let playerItem = CachingPlayerItem(url: url)
        
        player = AVPlayer(playerItem: playerItem)
        player.automaticallyWaitsToMinimizeStalling = false
        player.play()
    }

    // MARK: - implementationm delegate
    
    func reloadWords(word: String, url: String?, example: (String, String)?, isNew: Bool, useVoice: Bool) {
        lblMain.text = word
        voiceData = nil
        lblExample.isHidden = example == nil
        if let _example = example {
            let exampleText = "\(_example.0):\n\(_example.1)"
            let rangeOriginal = (exampleText as NSString).range(of: _example.0)
            let rangeTranslate = (exampleText as NSString).range(of: _example.1)
            let attribute = NSMutableAttributedString(string: exampleText)
            attribute.addAttributes([NSAttributedStringKey.font: UIFont(name: "Helvetica-Bold", size: 16)!, NSAttributedStringKey.foregroundColor: ThemeManager.mainTextColor], range: rangeOriginal)
            attribute.addAttributes([NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 16)!, NSAttributedStringKey.foregroundColor: ThemeManager.mainTextColor], range: rangeTranslate)
            
            lblExample.attributedText = attribute
        }
        voiceData = (word, url, useVoice)
        if isNew {
            cnstrProgress.constant = vbackgroundTimer.bounds.width - (vbackgroundTimer.bounds.width / CGFloat(presenter.words.count) * CGFloat(presenter.current))
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
            }
            changeVisibility()
            
            if CardsViewController.isVolumeEnabled && useVoice  {
                if let _url = url {
                    playTrack(url: _url)
                }
                else {
                    syntheseVoice(text: word)
                }
            }
        }
    }
}
