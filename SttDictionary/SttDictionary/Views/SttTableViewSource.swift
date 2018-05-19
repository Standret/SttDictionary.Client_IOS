//
//  SttTableViewSource.swift
//  SttDictionary
//
//  Created by Standret on 19.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

class SttTableViewSource<T>: NSObject, UITableViewDataSource {
    
    var _tableView: UITableView
    var _cellIdentifier: String
    
    var _collection: [T]! {
        didSet {
            _tableView.reloadData()
        }
    }
    
    init(tableView: UITableView, cellIdentifier: String) {
        _tableView = tableView
        _cellIdentifier = cellIdentifier
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _collection == nil ? 0 : _collection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: _cellIdentifier)! as! SttTableViewCell<T>
        cell.dataContext = _collection[indexPath.row]
        cell.prepareBind()
        return cell
    }
}