//
//  SearchLinkeWordsViewController.swift
//  SttDictionary
//
//  Created by Standret on 15.06.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import UIKit
import RxSwift

class SearchLinkedWordsViewController: SttViewController<SearchLinkedWordsPresenter>, SearchLinkedWordsDelegate {

    var wordsSource: SttTableViewSource<WordEntityCellPresenter>!
    var tagSource: SttTableViewSource<TagEntityCellPresenter>!
    
    var changeTextObservable: Observable<String>!
    var closeDelegate: (([(String, String)]) -> Void)!

    @IBOutlet weak var mainTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if presenter.contentType == MainContentType.words {
            wordsSource = SttTableViewSource(tableView: mainTable,
                                             cellIdentifiers: [SttIdentifiers(identifers: UIConstants.CellName.wordEntity)],
                                             collection: presenter.words)
        }
        else {
            tagSource = SttTableViewSource(tableView: mainTable,
                                           cellIdentifiers: [SttIdentifiers(identifers: UIConstants.CellName.tagEntity)],
                                           collection: presenter.tags)
        }
        mainTable.dataSource = presenter.contentType == MainContentType.words ? wordsSource : tagSource
        mainTable.reloadData()
        
        _ = changeTextObservable.subscribe(onNext: { [weak self] (stringRes) in
            self?.presenter.search(seachString: stringRes)
        })
    }
    
    func reloadWords() {
        //wordsSource?._collection = presenter.words
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        closeDelegate(presenter.selectedData)
    }
}
