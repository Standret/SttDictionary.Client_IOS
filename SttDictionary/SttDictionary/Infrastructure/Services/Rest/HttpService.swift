//
//  HttpService.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

protocol IHttpService {
    var url: String! { get set }
    var token: String { get set }
    var tokenType: String { get set }
    
    func get(controller: ApiConroller, data: [String:String], insertToken: Bool) -> Observable<(HTTPURLResponse, Data)>
    func post(controller: ApiConroller, data: [String:String], insertToken: Bool) -> Observable<(HTTPURLResponse, Data)>
    func post(controller: ApiConroller, dataAny: [String:Any], insertToken: Bool) -> Observable<(HTTPURLResponse, Data)>
}

extension IHttpService {
    func get(controller: ApiConroller, data: [String:String] = [:], insertToken: Bool = false) -> Observable<(HTTPURLResponse, Data)> {
        return self.get(controller: controller, data: data, insertToken: insertToken)
    }
    func post(controller: ApiConroller, data: [String:String] = [:], insertToken: Bool = false) -> Observable<(HTTPURLResponse, Data)> {
        return self.post(controller: controller, data: data, insertToken: insertToken)
    }
    func post(controller: ApiConroller, dataAny: [String:Any] = [:], insertToken: Bool = false) -> Observable<(HTTPURLResponse, Data)> {
        return self.post(controller: controller, dataAny: dataAny, insertToken: insertToken)
    }
}

class HttpService: IHttpService {
    
    var url: String!
    var token: String = ""
    var tokenType: String = ""
    var connectivity = Conectivity()
    
    init() { tokenType = "bearer" }
    
    func  get(controller: ApiConroller, data: [String:String], insertToken: Bool) -> Observable<(HTTPURLResponse, Data)> {
        let url = "\(self.url!)\(controller.get())"
        var _insertToken = insertToken
        
        return Observable<(HTTPURLResponse, Data)>.create { (observer) -> Disposable in
            Log.trace(message: url, key: Constants.httpKeyLog)
            
            if !self.connectivity.isConnected {
                sleep(Constants.timeWaitNextRequest)
                observer.onError(BaseError.connectionError(ConnectionError.noInternetConnection))
                return Disposables.create()
            }
            
            if self.token == "" {
                _insertToken = false
            }
            return requestData(.get, url, parameters: data, encoding: URLEncoding.default,
                               headers: _insertToken ? ["Authorization" : "\(self.tokenType) \(self.token)"] : nil)
                .subscribe(onNext: { (res, data) in
                    observer.onNext((res, data))
                    observer.onCompleted()
                }, onError: observer.onError(_:))
            }
            .configurateParamet()
    }
    
    
    func post(controller: ApiConroller, data: [String:String], insertToken: Bool) -> Observable<(HTTPURLResponse, Data)> {
        let url = "\(self.url!)\(controller.get())"
        var _insertToken = insertToken
        
        return Observable<(HTTPURLResponse, Data)>.create { (observer) -> Disposable in
            Log.trace(message: url, key: Constants.httpKeyLog)
            
            if !self.connectivity.isConnected {
                sleep(Constants.timeWaitNextRequest)
                observer.onError(BaseError.connectionError(ConnectionError.noInternetConnection))
                return Disposables.create()
            }
            
            if self.token == "" {
                _insertToken = false
            }
            return requestData(.post, url, parameters: data, encoding: URLEncoding.default,
                               headers: _insertToken ? ["Authorization" : "\(self.tokenType) \(self.token)"] : nil)
                .subscribe(onNext: { (res, data) in
                    observer.onNext((res, data))
                    observer.onCompleted()
                }, onError: observer.onError(_:), onCompleted: nil, onDisposed: nil)
            }
            .configurateParamet()
    }
    
    func post(controller: ApiConroller, dataAny: [String:Any], insertToken: Bool) -> Observable<(HTTPURLResponse, Data)> {
        let url = "\(self.url!)\(controller.get())"
        var _insertToken = insertToken
        
        return Observable<(HTTPURLResponse, Data)>.create { (observer) -> Disposable in
            Log.trace(message: url, key: Constants.httpKeyLog)
            
            if !self.connectivity.isConnected {
                sleep(Constants.timeWaitNextRequest)
                observer.onError(BaseError.connectionError(ConnectionError.noInternetConnection))
                return Disposables.create()
            }
            
            if self.token == "" {
                _insertToken = false
            }
            
            return requestData(.post, url, parameters: dataAny, encoding: JSONEncoding.default,
                               headers: _insertToken ? ["Authorization" : "\(self.tokenType) \(self.token)"] : nil)
                .subscribe(onNext: { (res, data) in
                    observer.onNext((res, data))
                    observer.onCompleted()
                }, onError: observer.onError(_:), onCompleted: nil, onDisposed: nil)
            }
            .configurateParamet()
    }
}

extension Observable {
    func configurateParamet() -> Observable<Element> {
        return self.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .timeout(Constants.timeout, scheduler: MainScheduler.instance)
            .retry(Constants.maxCountRepeatRequest)
    }
}


