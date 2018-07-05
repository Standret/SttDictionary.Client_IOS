//
//  SttTableViewSource.swift
//  SttDictionary
//
//  Created by Standret on 19.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SttTableViewSource<T: SttViewInjector>: NSObject, UITableViewDataSource {
    
    private var _tableView: UITableView
    
    private var _cellIdentifiers = [String]()
    var cellIdentifiers: [String] { return _cellIdentifiers }
    
    var useAnimation: Bool = false
    var maxAnimationCount = 2
    
    private var _collection: SttObservableCollection<T>!
    var collection: SttObservableCollection<T> { return _collection }
    
    private var disposables: Disposable?
    
    func updateSource(collection: SttObservableCollection<T>) {
        _collection = collection
        _tableView.reloadData()
        disposables?.dispose()
        disposables = _collection.observableObject.subscribe(onNext: { [weak self] (indexes, type) in
            if self?.maxAnimationCount ?? 0 < indexes.count {
                self?._tableView.reloadData()
            }
            else {
                switch type {
                case .reload:
                    self?._tableView.reloadData()
                case .delete:
                    self?._tableView.deleteRows(at: indexes.map({ IndexPath(row: $0, section: 0) }), with: self!.useAnimation ? .left : .none)
                case .insert:
                    self?._tableView.insertRows(at: indexes.map({ IndexPath(row: $0, section: 0) }), with: self!.useAnimation ? .middle : .none)
                case .update:
                    self?._tableView.reloadRows(at: indexes.map({ IndexPath(row: $0, section: 0) }), with: self!.useAnimation ? .fade : .none)
                }
            }
        })
    }
    
    init(tableView: UITableView, cellIdentifiers: [SttIdentifiers], collection: SttObservableCollection<T>) {
        
        for item in cellIdentifiers {
            if !item.isRegistered {
                tableView.register(UINib(nibName: item.nibName ?? item.identifers, bundle: nil), forCellReuseIdentifier: item.identifers)
            }
        }

        _tableView = tableView
        _cellIdentifiers.append(contentsOf: cellIdentifiers.map({ $0.identifers }))
        
        super.init()
        updateSource(collection: collection)
    }
    
    // MARK: -- todo: write init for [cellIdentifiers]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _collection == nil ? 0 : _collection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: _cellIdentifiers.first!)! as! SttTableViewCell<T>
        cell.presenter = _collection[indexPath.row]
        cell.prepareBind()
        return cell
    }
}
