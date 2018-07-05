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

    var changeTextObservable: Observable<String>!
    var wordsSource: SttTableViewSource<WordEntityCellPresenter>!
    var closeDelegate: (([(String, String)]) -> Void)!

    @IBOutlet weak var mainTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        wordsSource = SttTableViewSource(tableView: mainTable,
                                         cellIdentifiers: [SttIdentifiers(identifers: UIConstants.CellName.wordEntity)],
                                         collection: presenter.words)
        mainTable.dataSource = wordsSource
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
        
        closeDelegate(presenter.selectedWordsData)
    }
}
