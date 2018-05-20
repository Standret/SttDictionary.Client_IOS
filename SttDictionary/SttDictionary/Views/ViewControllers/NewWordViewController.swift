//
//  NewWordViewController.swift
//  SttDictionary
//
//  Created by Admin on 5/16/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit
import AlignedCollectionViewFlowLayout

class NewWordViewController: SttViewController<NewWordPresenter>, NewWordDelegate, UICollectionViewDelegateFlowLayout {
  
    // property
    
    var mainTranslateSource: SttCollectionViewSource<WorldCollectionCellPresenter>!
    let handlerMain = HandlerTextField()
    let handlerOriginalWord = HandlerTextField()
    
    // outlet
    
    @IBOutlet weak var btnAddTranslation: UIButton!
    @IBOutlet weak var tfWord: SttTextField!
    @IBOutlet weak var tfMainTranslation: SttTextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cnstrMainTranslationHeight: NSLayoutConstraint!
    
    
    @IBAction func closeClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveClick(_ sender: Any) {
        if !(tfWord.text ?? "").isEmpty {
            presenter.word = tfWord.text
            presenter.save.execute()
        }
    }
    @IBAction func addMainTranslateClick(_ sender: Any) {
        if !(tfMainTranslation.text ?? "").isEmpty {
            presenter.addNewMainTranslation(value: tfMainTranslation.text!)
            tfMainTranslation.text = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfWord.setBorder(color: UIColor(named: "border")!, size: 1)
        tfMainTranslation.setBorder(color: UIColor(named: "border")!, size: 1)
                
        tfWord.insets = UIConstants.insetsForTextField
        tfMainTranslation.insets = UIConstants.insetsForTextField
        
        tfWord.layer.cornerRadius = UIConstants.cornerRadius
        tfMainTranslation.layer.cornerRadius = UIConstants.cornerRadius
        
        handlerOriginalWord.addTargetReturnKey { (tf) in
            self.tfMainTranslation.becomeFirstResponder()
        }
        handlerMain.addTargetReturnKey { (tf) in
            self.addMainTranslateClick(tf)
        }
        
        tfMainTranslation.delegate = handlerMain
        tfWord.delegate = handlerOriginalWord
        
        btnAddTranslation.layer.cornerRadius = UIConstants.cornerRadius
        btnAddTranslation.clipsToBounds = true
        btnAddTranslation.tintColor = UIColor.white
        
        mainTranslateSource = SttCollectionViewSource<WorldCollectionCellPresenter>(collectionView: collectionView, cellIdentifier: "WordCollectionCell", collection: presenter.mainTranslation)
        
        collectionView.sizeToFit()
        cnstrMainTranslationHeight.constant = collectionView.contentSize.height
        collectionView.dataSource = mainTranslateSource
        collectionView.delegate = self
        
        let alignedFlowLayout = collectionView?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        alignedFlowLayout?.minimumLineSpacing = 4
        alignedFlowLayout?.minimumInteritemSpacing = 4
        
        presenter.save.addHandler(start: {
            let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            indicator.startAnimating()
            let indicatorButton = UIBarButtonItem(customView: indicator)
            indicatorButton.isEnabled = false
            self.navigationItem.setRightBarButton(indicatorButton, animated: true)
        }, end: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((presenter.mainTranslation[indexPath.row].word ?? "") as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 18)!]).width + 13, height: 35)
    }
    
    // protocols presenter implement
    
    func reloadMainCollectionCell() {
        mainTranslateSource._collection = presenter.mainTranslation
        collectionView.sizeToFit()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.cnstrMainTranslationHeight.constant = self.collectionView.contentSize.height
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
}
