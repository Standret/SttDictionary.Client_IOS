//
//  WordCollectionCellSource.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/16/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit
import AlignedCollectionViewFlowLayout

class WordCollectionCellSource: SttCollectionViewSource<WorldCollectionCellPresenter>, UICollectionViewDelegateFlowLayout {
    init (collectionView: UICollectionView, _collection: SttObservableCollection<WorldCollectionCellPresenter>) {
        super.init(collectionView: collectionView, cellIdentifier: "WordCollectionCell", collection: _collection)
        
        let alignedFlowLayout = collectionView.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        alignedFlowLayout?.minimumLineSpacing = 4
        alignedFlowLayout?.minimumInteritemSpacing = 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collection[indexPath.row].word ?? "") as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 18)!]).width + 13, height: 35)
    }
}
