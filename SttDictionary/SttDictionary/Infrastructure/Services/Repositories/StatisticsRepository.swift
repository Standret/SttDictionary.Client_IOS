//
//  StatisticsRepository.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/7/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

protocol StatisticsRepositoriesType {
    func getCount() -> Observable<CountApiModel>
    
    func updateStatistics(skip: Int) -> Observable<Int>
    
    func getLocalCount(type: ElementType) -> Observable<Int>
    func getStatistics(type: ElementType) -> Observable<[WordStatisticsApiModel]>
    
    func getNewOriginal() -> Observable<[WordStatisticsApiModel]>
    func getNewTranslate() -> Observable<[WordStatisticsApiModel]>
    func getRepeatOriginal() -> Observable<[WordStatisticsApiModel]>
    func getRepeatTranslate() -> Observable<[WordStatisticsApiModel]>

    
    func removeAll() -> Completable
}

class StatisticsRepositories: StatisticsRepositoriesType {
    
    var _apiDataProvider: ApiDataProviderType!
    var _storageProvider: RealmStorageProviderType!
    
    init () {
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    func getCount() -> Observable<CountApiModel> {
        return _apiDataProvider.getCount()
    }
    
    func updateStatistics(skip: Int) -> Observable<Int> {
        return _apiDataProvider.getWordsStatistics(skip: skip)
            .flatMap({ statistics in
                self._storageProvider.statistics.saveMany(models: statistics)
                    .toObservable()
                    .map({ _ in statistics })
            }).map({ $0.count })
    }
    
    func getLocalCount(type: ElementType) -> Observable<Int> {
        return _storageProvider.statistics.count(filter: QueryFactories.getDefaultQuery(type: type))
    }
    func getStatistics(type: ElementType) -> Observable<[WordStatisticsApiModel]> {
        return _storageProvider.statistics.getMany(filter: QueryFactories.getDefaultQuery(type: type)).map({ $0.map({ $0.deserialize() }) })
    }
    
    func removeAll() -> Completable {
        return _storageProvider.answer.deleteAll()
    }
    
    func getNewOriginal() -> Observable<[WordStatisticsApiModel]> {
        return _storageProvider.statistics.getMany(filter: QueryFactories.getStatisticsQuery(type: .newOriginal))
                .map({ $0.map({ $0.deserialize() }) })
    }
    func getNewTranslate() -> Observable<[WordStatisticsApiModel]> {
        return _storageProvider.statistics.getMany(filter: QueryFactories.getStatisticsQuery(type: .newTranslation))
                .map({ $0.map({ $0.deserialize() }) })
    }
    func getRepeatOriginal() -> Observable<[WordStatisticsApiModel]> {
        return _storageProvider.statistics.getMany(filter: QueryFactories.getStatisticsQuery(type: .repeatOriginal))
                .map({ $0.map({ $0.deserialize() }) })
    }
    func getRepeatTranslate() -> Observable<[WordStatisticsApiModel]> {
        return _storageProvider.statistics.getMany(filter: QueryFactories.getStatisticsQuery(type: .repeatTranslation))
            .map({ $0.map({ $0.deserialize() }) })
    }
}
