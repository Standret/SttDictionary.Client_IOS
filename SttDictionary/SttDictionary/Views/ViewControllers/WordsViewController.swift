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
    @IBOutlet weak var contentControl: UISegmentedControl!
    
    var wordsSource: SttTableViewSource<WordEntityCellPresenter>!
    var tagSource: SttTableViewSource<TagEntityCellPresenter>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        wordsSource = SttTableViewSource(tableView: mainTable,
                                         cellIdentifiers: [SttIdentifiers(identifers: UIConstants.CellName.wordEntity)],
                                         collection: presenter.words)
        tagSource = SttTableViewSource(tableView: mainTable,
                                       cellIdentifiers: [SttIdentifiers(identifers: UIConstants.CellName.tagEntity)],
                                       collection: presenter.tags)
        wordsSource.addEndScrollHandler(delegate: self, callback: { $0.presenter.search(seachString: $0.searchBar.text ?? "") })
        
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: widthScreen, height: 1))
        footer.backgroundColor = UIColor.clear
        
        mainTable.tableFooterView = footer
        mainTable.dataSource = wordsSource
        
        _ = ThemeManager.observer.subscribe(onNext: { _ in self.prepateTheme() })
        
        contentControl.addTarget(self, action: #selector(didChangeValueOfSegmentControl(_:)), for: .valueChanged)
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.search(seachString: searchBar.text ?? "")
    }
    
    @objc func didChangeValueOfSegmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            presenter.contentType = .words
            mainTable.dataSource = wordsSource
        case 1:
            presenter.contentType = .tags
            mainTable.dataSource = tagSource
        default: break;
        }
        
        mainTable.reloadData()
    }
    
    // MARK: implement delegate
    
}
