//
//  WordCollectionCell.swift
//  SttDictionary
//
//  Created by Standret on 19.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import UIKit

class WordCollectionCell: SttCollectionViewCell<WorldCollectionCellPresenter> {
    @IBOutlet weak var lblWord: UILabel!
    
    override func prepareBind() {
        layer.cornerRadius = UIConstants.cornerRadiusWordCard
        
        lblWord.text = dataContext.word
    }
}
