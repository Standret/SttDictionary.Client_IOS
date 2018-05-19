//
//  SttCollectionViewSource.swift
//  SttDictionary
//
//  Created by Standret on 19.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

class SttCollectionViewSource<T>: NSObject, UICollectionViewDataSource {
    
    var _collectionView: UICollectionView
    var _cellIdentifier: String
    
    var _collection: [T]! {
        didSet {
            _collectionView.reloadData()
        }
    }
    
    init(collectionView: UICollectionView, cellIdentifier: String, collection: [T]) {
        _collectionView = collectionView
        _cellIdentifier = cellIdentifier
        _collection = collection
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
