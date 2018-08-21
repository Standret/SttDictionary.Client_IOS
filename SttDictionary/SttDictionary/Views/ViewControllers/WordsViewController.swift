//
//  WordsViewController.swift
//  SttDictionary
//
//  Created by Standret on 5/16/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

class WordViewController: SttViewController<WordPresenter>, WordDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var separator: UIView!
    
    var wordsSource: SttTableViewSource<WordEntityCellPresenter>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        wordsSource = SttTableViewSource(tableView: mainTable,
                                         cellIdentifiers: [SttIdentifiers(identifers: UIConstants.CellName.wordEntity)],
                                         collection: presenter.words)
        
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: widthScreen, height: 1))
        footer.backgroundColor = UIColor.clear
        mainTable.tableFooterView = footer
        mainTable.dataSource = wordsSource
        
        ThemeManager.observer.subscribe(onNext: { _ in self.prepateTheme() })
    }
    
    func prepateTheme() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barTintColor = ThemeManager.navigationBarBackgroundColor
        
        searchBar.barTintColor = ThemeManager.mainBackgroundColor
        
        if let textfield = searchBar.value(forKey: "_searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                backgroundview.layer.cornerRadius = UIConstants.cornerRadius;
                backgroundview.layer.borderColor = UIColor(named: "border")!.cgColor
                backgroundview.layer.borderWidth = 1
                backgroundview.clipsToBounds = true;
            }
        }
        
        mainTable.backgroundColor = ThemeManager.mainBackgroundColor
        mainTable.separatorColor = ThemeManager.borderColor
        separator.backgroundColor = ThemeManager.borderColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        prepateTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //prepateTheme()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.search(seachString: searchBar.text)
    }
    
    // MARK: implement delegate
    
}
