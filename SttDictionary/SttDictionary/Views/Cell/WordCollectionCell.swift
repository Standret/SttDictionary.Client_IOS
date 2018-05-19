//
//  WordCollectionCell.swift
//  SttDictionary
//
//  Created by Standret on 19.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import UIKit

class WordCollectionCell: SttCollectionViewCell<WorldCollectionCellPresenter>, WordCollectionCellDelegate {
    @IBOutlet weak var lblWord: UILabel!
    
    override func prepareBind() {
        layer.cornerRadius = UIConstants.cornerRadiusWordCard
        
        isUserInteractionEnabled = true
        lblWord.text = dataContext.word
    }
}
