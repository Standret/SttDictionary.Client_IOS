//
//  TagEntityCell.swift
//  SttDictionary
//
//  Created by Standret on 21.08.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import UIKit

class TagEntityCell: SttTableViewCell<TagEntityCellPresenter>, TagEntityCellDelegate {
    
    @IBOutlet weak var lblCount: HighlightsUILabel!
    @IBOutlet weak var lblName: MainUILabel!
    
    override func prepareBind() {
        super.prepareBind()
        lblName.text = presenter.name
        lblCount.text = "\(presenter.wordCount!)"
        reloadState()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClick(_:))))
        prepateTheme()
        _ = ThemeManager.observer.subscribe(onNext: { _ in self.prepateTheme() })
    }
    
    @objc func onClick(_ sender: Any) {
        presenter.onClick()
    }
    
    func reloadState() {
        backgroundColor = presenter.isSelect ? UIColor(named: "selectedItemColor") : ThemeManager.secondaryBackgroundColor
    }
    func prepateTheme() {
        backgroundColor = (presenter?.isSelect ?? false) ? UIColor(named: "selectedItemColor") : ThemeManager.secondaryBackgroundColor
    }
}
