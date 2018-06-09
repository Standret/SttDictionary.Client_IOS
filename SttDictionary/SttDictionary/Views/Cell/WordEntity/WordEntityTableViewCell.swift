//
//  WordEntityTableViewCell.swift
//  SttDictionary
//
//  Created by Admin on 5/20/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import UIKit

class WordEntityTableViewCell: SttTableViewCell<WordEntityCellPresenter>, WordEntityCellDelegate {

    @IBOutlet weak var lblWord: UILabel!
    @IBOutlet weak var lblTranslations: UILabel!
    @IBOutlet weak var lblTags: UILabel!
    @IBOutlet weak var syncStatus: UIView!
    @IBOutlet weak var lblDevInfo: UILabel!
    @IBOutlet weak var lblNextDay: UILabel!
    
    override func prepareBind() {
        lblWord.text = dataContext.word
        lblTranslations.text = dataContext.mainTranslations
        lblTags.text = dataContext.tags
        syncStatus.backgroundColor = dataContext.status ? UIColor.green : UIColor.red
        
        let nextOrrDate = dataContext.nextOriginalDate != nil ? ShortDateConverter().convert(value: dataContext.nextOriginalDate!) : "none"
        let nextTransDate = dataContext.nextTranslationDate != nil ? ShortDateConverter().convert(value: dataContext.nextTranslationDate!) : "none"
        
        lblNextDay.text = "\(nextOrrDate) / \(nextTransDate)"
        lblDevInfo.text = dataContext.devInfo
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        syncStatus.createCircle()
        syncStatus.backgroundColor = dataContext.status ? UIColor.green : UIColor.red
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
