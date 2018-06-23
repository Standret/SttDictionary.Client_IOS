//
//  SttCollectionViewSource.swift
//  SttDictionary
//
//  Created by Standret on 19.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class SttCollectionViewSource<T: SttViewInjector>: NSObject, UICollectionViewDataSource {
    
    private var _collectionView: UICollectionView
    private var _cellIdentifier: String
    private var _collection: SttObservableCollection<T>!
    var collection: SttObservableCollection<T> { return _collection }
    
    private var disposables: Disposable?
    
    func updateSource(collection: SttObservableCollection<T>) {
        _collection = collection
        _collectionView.reloadData()
        disposables?.dispose()
        disposables = _collection.observableObject.subscribe(onNext: { [weak self] (indexes, type) in
                switch type {
                case .reload:
                    self?._collectionView.reloadData()
                case .delete:
                    self?._collectionView.deleteItems(at: indexes.map({ IndexPath(row: $0, section: 0) }))
                case .insert:
                    self?._collectionView.insertItems(at: indexes.map({ IndexPath(row: $0, section: 0) }))
                case .update:
                    self?._collectionView.reloadItems(at: indexes.map({ IndexPath(row: $0, section: 0) }))
                }
        })
    }
    
    init(collectionView: UICollectionView, cellIdentifier: String, collection: SttObservableCollection<T>) {
        _collectionView = collectionView
        _cellIdentifier = cellIdentifier
        super.init()
        updateSource(collection: collection)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _collection == nil ? 0 : _collection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = _collectionView.dequeueReusableCell(withReuseIdentifier: _cellIdentifier, for: indexPath) as! SttCollectionViewCell<T>
        cell.dataContext = _collection[indexPath.row]
        cell.prepareBind()
        return cell
    }

}
