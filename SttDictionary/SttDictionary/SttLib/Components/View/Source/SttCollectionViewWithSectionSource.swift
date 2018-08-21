//
//  SttCollectionViewWithSectionSource.swift
//  YURT
//
//  Created by Standret on 30.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//


import Foundation
import UIKit
import RxSwift

class SttCollectionViewWithSectionSource<TCell: SttViewInjector, TSection: SttViewInjector>: NSObject, UICollectionViewDataSource {
    
    var _collectionView: UICollectionView
    
    private var _sectionIdentifier: [String]
    var sectionIdentifier: [String] { return _sectionIdentifier }
    
    private var _cellIdentifier: [String]
    var cellIdentifier: [String] { return _cellIdentifier }
    
    private var _collection: SttObservableCollection<(SttObservableCollection<TCell>, TSection)>?
    var collection: SttObservableCollection<(SttObservableCollection<TCell>, TSection)>? { return _collection }
    
    private var disposables = [Disposable]()
    
    func updateSource(collection: SttObservableCollection<(SttObservableCollection<TCell>, TSection)>) {
        _collection = collection
        _collectionView.reloadData()
        for item in disposables {
            item.dispose()
        }
        for item in collection {
            disposables.append(item.0.observableObject.subscribe(onNext: { [weak self] (indexes, type) in
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
            }))
        }
    }
    
    init (collectionView: UICollectionView, cellIdentifiers: [SttIdentifiers], sectionIdentifier: [String], collection: SttObservableCollection<(SttObservableCollection<TCell>, TSection)>) {
        _collectionView = collectionView
        _sectionIdentifier = sectionIdentifier
        _cellIdentifier = cellIdentifiers.map({ $0.identifers })
        
        for item in cellIdentifiers {
            if !item.isRegistered {
                collectionView.register(UINib(nibName: item.nibName ?? item.identifers, bundle: nil), forCellWithReuseIdentifier: item.identifers)
            }
        }
        
        super.init()
        updateSource(collection: collection)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _collection?[section].0.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: _cellIdentifier.first!, for: indexPath) as! SttCollectionViewCell<TCell>
        cell.presenter = _collection![indexPath.section].0[indexPath.row]
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = _collection?.count ?? 0
        print(count)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: _sectionIdentifier.first!, for: indexPath) as! SttTCollectionReusableView<TSection>
        view.dataContext = _collection?[indexPath.section].1
        view.prepareBind()
        return view
    }
}
