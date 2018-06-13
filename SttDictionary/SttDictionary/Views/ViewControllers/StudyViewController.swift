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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.reloadData()
//        let url = URL(string: "http://192.168.0.66:10000/devstoreaccount1/sttdictionary/pronuniation/schedule.mp3")!
//        let playerItem = CachingPlayerItem(url: url)
//        player = AVPlayer(playerItem: playerItem)
//        player.automaticallyWaitsToMinimizeStalling = false
//        player.play()
//        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//        try! AVAudioSession.sharedInstance().setActive(true)
//        if player.rate != 0 && player.error == nil{
//            print("Playing")
//        }else{
//            print("Error Playing")
//        }
    }
    
    // MARK: -- implementation delegate
    
    func reloadStatus() {
        lblStatistics.text = "Today original cards: \(presenter.newWords.count) | \(presenter.repeatWords.count)\ntranslation cards: \(presenter.newTranslationWords.count) | \(presenter.repeatTranslationWords.count)"
    }
}
