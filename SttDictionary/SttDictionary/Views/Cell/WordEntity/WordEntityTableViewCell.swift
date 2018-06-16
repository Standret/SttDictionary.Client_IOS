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
    //@IBOutlet weak var lblDevInfo: UILabel!
    @IBOutlet weak var lblNextDay: UILabel!
    
    override func prepareBind() {
        super.prepareBind()
        
        lblWord.text = dataContext.word
        lblTranslations.text = dataContext.mainTranslations
        lblTags.text = dataContext.tags
        syncStatus.backgroundColor = dataContext.status ? UIColor.green : UIColor.red
        
        let nextOrrDate = dataContext.nextOriginalDate != nil ? ShortDateConverter().convert(value: dataContext.nextOriginalDate!) : "none"
        let nextTransDate = dataContext.nextTranslationDate != nil ? ShortDateConverter().convert(value: dataContext.nextTranslationDate!) : "none"
        
        lblNextDay.text = "\(nextOrrDate) / \(nextTransDate)"
        //lblDevInfo.text = dataContext.devInfo
        
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClick(_:))))
    }
    
    func reloadState() {
        backgroundColor = dataContext.isSelect ? UIColor(named: "selectedItemColor") : UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        syncStatus.createCircle()
        syncStatus.backgroundColor = dataContext.status ? UIColor.green : UIColor.red
    }
    
    @objc func onClick(_ sender: Any) {
        dataContext.onClick()
    }
}
