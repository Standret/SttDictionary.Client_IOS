//
//  UnitOfWork.swift
//  SttDictionary
//
//  Created by Standret on 14.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol IUnitOfWork {
    var word: Repository<WordApiModel, RealmWord> { get }
    var tag: Repository<TagApiModel, RealmTag> { get }
}

class UnitOfWork: IUnitOfWork {
    
    private lazy var _word = Repository<WordApiModel, RealmWord> (singleton: false)
    
    var word: Repository<WordApiModel, RealmWord> { return _word }
}
