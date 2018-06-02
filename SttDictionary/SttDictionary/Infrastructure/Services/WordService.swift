//
//  WordService.swift
//  SttDictionary
//
//  Created by Admin on 5/20/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

protocol IWordService {
    func getWord(searchString: String?) -> Observable<[WordEntityCellPresenter]>
    func createWord(word: String, translations: [String]) -> Observable<Bool>
    func exists(word: String) -> Observable<Bool>
    
    var observe: Observable<WordEntityCellPresenter> { get }
}

class WordServie: IWordService {
    
    var _unitOfWork: IUnitOfWork!
    var _notificationError: INotificationError!
    
    var observe: Observable<WordEntityCellPresenter> { return _notificationError.useError(observable: _unitOfWork.word.observe(on: [RealmStatus.Inserted]).map( { WordEntityCellPresenter(element: $0.0) } )) }
    
    init () {
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    func getWord(searchString: String?) -> Observable<[WordEntityCellPresenter]> {
        var query: String?
        if let _searchStr = searchString {
            if _searchStr.starts(with: "--:") {
                print("sys query")
            }
            else if !_searchStr.isEmpty {
                query = "originalWorld contains[cd] '\(_searchStr)' or any translations.value contains[cd] '\(_searchStr)'"
            }
        }
        return _notificationError.useError(observable: _unitOfWork.word.getManyOriginal(filter: query))
            .map( { $0.map( { WordEntityCellPresenter(fromObject: $0) } ) } )
    }
    
    func createWord(word: String, translations: [String]) -> Observable<Bool> {
        return _notificationError.useError(observable: _unitOfWork.word.saveOne(model: WordFactories.createWordModel(word: word, translations: translations)).toEmptyObservable(ofType: Bool.self))
    }
    
    func exists(word: String) -> Observable<Bool> {
        return _notificationError.useError(observable: _unitOfWork.word.exists(filter: "originalWorld = '\(word)'"))
    }
}
