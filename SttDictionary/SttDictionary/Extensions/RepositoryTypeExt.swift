//
//  RepositoryTypeExt.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/3/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

extension RepositoryType
where TEntity: Defaultable {
    func getOrCreateSingletoon() -> Observable<TRealm> {
        return self.exists(filter: nil)
            .flatMap({ (result) -> Observable<TRealm> in
                if (result) {
                    return self.getOne(filter: nil)
                }
                return self.saveOne(model: FactoryDefaultsObject.create(ofType: TEntity.self))
                    .toObservable()
                    .flatMap({ _ in self.getOne(filter: nil) })
            })
    }
}

extension RepositoryType {
    func getMany(filter: String? = nil, sortBy: String? = nil, isAsc: Bool = true, skip: Int = 0, take: Int = Int.max) -> Observable<[TRealm]> {
        return self.getMany(filter: filter, sortBy: sortBy, isAsc: isAsc, skip: skip, take: take)
    }
}
