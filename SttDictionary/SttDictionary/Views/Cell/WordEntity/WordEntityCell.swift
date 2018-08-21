//
//  WordEntityTableViewCell.swift
//  SttDictionary
//
//  Created by Admin on 5/20/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import UIKit

class WordEntityCell: SttTableViewCell<WordEntityCellPresenter>, WordEntityCellDelegate {

    @IBOutlet weak var lblWord: MainUILabel!
    @IBOutlet weak var lblTranslations: MainUILabel!
    @IBOutlet weak var lblTags: UILabel!
    @IBOutlet weak var syncStatus: UIView!
    //@IBOutlet weak var lblDevInfo: UILabel!
    @IBOutlet weak var lblNextDay: UILabel!
    
    override func prepareBind() {
        super.prepareBind()
        
        lblWord.text = presenter.word
        lblTranslations.text = presenter.mainTranslations
        lblTags.text = presenter.tags
        syncStatus.backgroundColor = presenter.status ? UIColor.green : UIColor.red
        
        let nextOrrDate = presenter.nextOriginalDate != nil ? ShortDateConverter().convert(value: presenter.nextOriginalDate!) : "none"
        let nextTransDate = presenter.nextTranslationDate != nil ? ShortDateConverter().convert(value: presenter.nextTranslationDate!) : "none"
        
        lblNextDay.text = "\(nextOrrDate) / \(nextTransDate)"
        //lblDevInfo.text = presenter.devInfo
        
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClick(_:))))
        reloadState()
    }
    
    func reloadState() {
        backgroundColor = presenter.isSelect ? UIColor(named: "selectedItemColor") : ThemeManager.secondaryBackgroundColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        syncStatus.createCircle()
        prepateTheme()
        ThemeManager.observer.subscribe(onNext: { _ in self.prepateTheme() })
    }
    
    func prepateTheme() {
        backgroundColor = (presenter?.isSelect ?? false) ? UIColor(named: "selectedItemColor") : ThemeManager.secondaryBackgroundColor
    }
    
    @objc func onClick(_ sender: Any) {
        presenter.onClick()
    }
}
