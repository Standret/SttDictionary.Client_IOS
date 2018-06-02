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
    func getAllWord() -> Observable<[WordEntityCellPresenter]>
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
    
    func getAllWord() -> Observable<[WordEntityCellPresenter]> {
        return _notificationError.useError(observable: _unitOfWork.word.getManyOriginal(filter: nil))
            .map( { $0.map( { WordEntityCellPresenter(fromObject: $0) } ) } )
        
//        return Observable<[WordEntityCellPresenter]>.create { (observer) -> Disposable in
//            return self._notificationError.useError(observable: self._unitOfWork.word.getMany(filter: nil))
//                .subscribe(onNext: { observer.onNext($0.map({ WordEntityCellPresenter(element: $0) }))})
//        }
    }
    
    func createWord(word: String, translations: [String]) -> Observable<Bool> {
        return _notificationError.useError(observable: _unitOfWork.word.saveOne(model: WordFactories.createWordModel(word: word, translations: translations)).toEmptyObservable(ofType: Bool.self))
    }
    
    func exists(word: String) -> Observable<Bool> {
        return _notificationError.useError(observable: _unitOfWork.word.exists(filter: "originalWorld = '\(word)'"))
    }
}
