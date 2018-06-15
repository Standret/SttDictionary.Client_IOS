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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _ = changeTextObservable.subscribe(onNext: { (stringRes) in
            print(stringRes)
        })
    }
}
