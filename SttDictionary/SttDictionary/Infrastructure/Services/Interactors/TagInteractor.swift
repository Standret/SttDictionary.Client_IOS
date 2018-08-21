//
//  TagInteractor.swift
//  SttDictionary
//
//  Created by Standret on 21.08.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

protocol TagInteractorType {
    func get(searchStr: String?, skip: Int) -> Observable<[TagEntityCellPresenter]>
}

class TagInteractor: TagInteractorType {
    
    var _tagRepositories: TagRepositoriesType!
    var _notificationError: NotificationErrorType!
    
    init() {
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    func get(searchStr: String?, skip: Int) -> Observable<[TagEntityCellPresenter]> {
        return _tagRepositories.get(searchStr: searchStr, skip: skip, take: 50).map({ $0.map { TagEntityCellPresenter(fromObject: $0) } })
    }
}
