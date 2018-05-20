//
//  WordsViewController.swift
//  SttDictionary
//
//  Created by Standret on 5/16/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

class WordViewController: SttViewController<WordPresenter>, WordDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mainTable: UITableView!
    
    var wordsSource: WordEntityCellSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        wordsSource = WordEntityCellSource(tableView: mainTable, cellIdentifier: "WordEntityCell", collection: presenter.words)
     //   mainTable.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 1))
        mainTable.dataSource = wordsSource
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.white
                backgroundview.layer.cornerRadius = UIConstants.cornerRadius;
                backgroundview.layer.borderColor = UIColor(named: "border")!.cgColor
                backgroundview.layer.borderWidth = 1
                backgroundview.clipsToBounds = true;
            }
        }
    }
    
    func reloadWords() {
        if let _words = presenter?.words {
            wordsSource?._collection = _words
        }
    }
}
