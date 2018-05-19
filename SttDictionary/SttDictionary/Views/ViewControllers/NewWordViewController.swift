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

class NewWordViewController: SttViewController<NewWordPresenter>, NewWordDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
  
    // property
    
    var mainTranslateSource: SttCollectionViewSource<WorldCollectionCellPresenter>!
    
    // outlet
    
    @IBOutlet weak var btnAddTranslation: UIButton!
    @IBOutlet weak var tfWord: SttTextField!
    @IBOutlet weak var tfMainTranslation: SttTextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func closeClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        
        btnAddTranslation.layer.cornerRadius = UIConstants.cornerRadius
        btnAddTranslation.clipsToBounds = true
        btnAddTranslation.tintColor = UIColor.white
        
        mainTranslateSource = SttCollectionViewSource<WorldCollectionCellPresenter>(collectionView: collectionView, cellIdentifier: "WordCollectionCell", collection: presenter.mainTranslation)
        
        collectionView.dataSource = mainTranslateSource
        collectionView.delegate = self
        
        let alignedFlowLayout = collectionView?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        alignedFlowLayout?.minimumLineSpacing = 4
        alignedFlowLayout?.minimumInteritemSpacing = 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        print(flowLayout.sectionInset)
        return CGSize(width: ((presenter.mainTranslation[indexPath.row].word ?? "") as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 18)!]).width + 13, height: 35)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        print("Got clicked! \(indexPath)")
    }
    
    // protocols presenter implement
    
    func reloadMainCollectionCell() {
        mainTranslateSource._collection = presenter.mainTranslation
    }
    
}
