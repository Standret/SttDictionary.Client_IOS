//
//  Repository.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol RealmCodable {
    func serialize()
}

protocol RealmDecodable {
    func deserialize()
}

protocol IRepository {
    associatedtype TEntity: RealmCodable, RealmDecodable
    
    func save(model: TEntity)
    
}

class Repository<T>: IRepository
where T: RealmCodable, T: RealmDecodable {
    
    typealias TEntity = T
    
    func save(model: T) {
        
    }
}
