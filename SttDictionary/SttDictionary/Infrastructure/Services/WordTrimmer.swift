//
//  WordTrimmer.swift
//  SttDictionary
//
//  Created by Standret on 21.08.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift
import SINQ

extension ObservableType
where E == [WordApiModel] {
    
    func trimSameIdWords(todayTrainedWords: Observable<[WordApiModel]>, key: String = "") -> Observable<E> {
        return Observable.zip(self, todayTrainedWords, resultSelector: { (targetWords, todayTrained) -> [WordApiModel] in
            
            //print ("\ntrimSameIdWords \(key)")
            //print(targetWords.map({ $0.originalWorld }))
            //print(todayTrained.map({ $0.originalWorld }))
            //delete all linked words which trained today
            var targetResult = targetWords
            
            for item in todayTrained {
                if let index = targetResult.index(where: { $0.id == item.id }) {
                    targetResult.remove(at: index)
                }
            }
            
            //print(targetResult.map({ $0.originalWorld }))
            return targetResult
        })
    }
    
    func trimLinkedWords(key: String = "") -> Observable<E> {
        return self.map({ (targetWords) -> [WordApiModel] in
            
            var targetResult = [WordApiModel]()
            // print ("\ntrim \(key)")
            // print(targetWords.map({ $0.originalWorld }))
            // delete from target list (get first word and other linked delete)
            for item in targetWords {
                if !sinq(item.linkedWords ?? []).any({ lid in sinq(targetResult).any({ $0.id == lid }) }) {
                    targetResult.append(item)
                }
            }
            //  print(targetResult.map({ $0.originalWorld }))
            return targetResult
        })
    }
    
    func trimLinkedWordsFrom(todayTrainedWords: Observable<[WordApiModel]>, key: String = "") -> Observable<E> {
        return Observable.zip(self, todayTrainedWords, resultSelector: { (targetWords, todayTrained) -> [WordApiModel] in
            
            //print ("\ntrim from \(key)")
            //  print(targetWords.map({ $0.originalWorld }))
            //  print(todayTrained.map({ $0.originalWorld }))
            // delete all linked words which trained today
            var targetResult = targetWords
            
            for item in todayTrained {
                for id in (item.linkedWords ?? []) {
                    if let _indexForDelete = targetResult.index(where: { $0.id == id }) {
                        targetResult.remove(at: _indexForDelete)
                    }
                }
            }
            
            // print(targetResult.map({ $0.originalWorld }))
            return targetResult
        })
    }
    
    private func deleteLinkedWords(from: [WordApiModel], with: [WordApiModel]) -> [WordApiModel] {
        
        var targetResult = from
        
        for item in with {
            for id in (item.linkedWords ?? []) {
                if let _indexForDelete = targetResult.index(where: { $0.id == id }) {
                    targetResult.remove(at: _indexForDelete)
                }
            }
        }
        
        return targetResult
    }
}
