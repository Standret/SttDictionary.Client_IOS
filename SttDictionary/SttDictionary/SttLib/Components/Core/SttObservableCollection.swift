//
//  SttObservableCollection.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/16/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

enum NotifyCollectionType {
    case delete, insert, update, reload
}

class SttObservableCollection<T>: Collection {
    
    private var datas = [T]()
    private var notifyPublisher = PublishSubject<([Int], NotifyCollectionType)>()
    
    public var observableObject: Observable<([Int], NotifyCollectionType)> { return notifyPublisher }
    public var count: Int { return datas.count }
    public var capacity: Int { return datas.capacity }
    public var startIndex: Int { return datas.startIndex }
    public var endIndex: Int { return datas.endIndex }
    
    func index(after i: Int) -> Int {
        return datas.index(after: i)
    }
    
    func append(_ newElement: T) {
        datas.append(newElement)
        notifyPublisher.onNext(([datas.count - 1], .insert))
    }
    func append(contentsOf sequence: [T]) {
        if sequence.count > 0 {
            let startIndex = datas.count
            datas.append(contentsOf: sequence)
            notifyPublisher.onNext((Array(startIndex...(datas.count - 1)), .insert))
        }
    }
    func remove(at index: Int) {
        datas.remove(at: index)
        notifyPublisher.onNext(([index], .delete))
    }
    func insert(_ newElement: T, at index: Int) {
        datas.insert(newElement, at: index)
        notifyPublisher.onNext(([index], .insert))
    }
    func index(where predicate: (T) throws -> Bool) rethrows -> Int? {
        return try datas.index(where: predicate)
    }
    func removeAll() {
        datas.removeAll()
        notifyPublisher.onNext(([], .reload))
    }
    
    subscript(index: Int) -> T {
        get { return datas[index] }
        set(newValue) {
            datas[index] = newValue
            notifyPublisher.onNext(([index], .update))
        }
    }
}
