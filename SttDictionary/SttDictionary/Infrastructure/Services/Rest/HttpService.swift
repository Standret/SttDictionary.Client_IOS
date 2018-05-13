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

protocol IHttpService {
    var url: String! { get set }
    var token: String! { get set }
    var tokenType: String! { get set }
    
    func get(controller: ApiConroller, data: [String:String], insertToken: Bool) -> Observable<(HTTPURLResponse, Data)>
    func post(controller: ApiConroller, data: [String:String], insertToken: Bool) -> Observable<(HTTPURLResponse, Data)>
}

class HttpService: IHttpService {
    
    var url: String!
    var token: String!
    var tokenType: String!
    var connectivity = Conectivity()
    
    init() { tokenType = "bearer" }
    
    func  get(controller: ApiConroller, data: [String:String], insertToken: Bool) -> Observable<(HTTPURLResponse, Data)> {
        let url = "\(self.url!)\(controller.get())"
        
        return Observable<(HTTPURLResponse, Data)>.create { (observer) -> Disposable in
            print("--> \(url)")
            
            if !self.connectivity.isConnected {
                sleep(Constants.timeWaitNextRequest)
                observer.onError(ApiError.noInternetConnectionError)
                return Disposables.create()
            }
            
            let tok = "\(self.tokenType!) \(self.token!)"
            return requestData(.get, url, parameters: data, encoding: URLEncoding.default,
                               headers: insertToken ? ["Authorization" : tok] : nil)
                .subscribe(onNext: { (res, data) in
                    observer.onNext((res, data))
                    observer.onCompleted()
                }, onError: observer.onError(_:), onCompleted: nil, onDisposed: nil)
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .timeout(Constants.timeout, scheduler: MainScheduler.instance)
            .retry(Constants.maxCountRepeatRequest)
    }
    
    
    func post(controller: ApiConroller, data: [String:String], insertToken: Bool) -> Observable<(HTTPURLResponse, Data)> {
        let url = "\(self.url!)\(controller.get())"
        
        return Observable<(HTTPURLResponse, Data)>.create { (observer) -> Disposable in
            print("--> \(url)")
            
            if !self.connectivity.isConnected {
                sleep(Constants.timeWaitNextRequest)
                observer.onError(ApiError.noInternetConnectionError)
                return Disposables.create()
            }
            
            return requestData(.post, url, parameters: data, encoding: URLEncoding.default,
                               headers: insertToken ? ["Authorization" : "\(self.tokenType) \(self.token)"] : nil)
                .subscribe(onNext: { (res, data) in
                    observer.onNext((res, data))
                    observer.onCompleted()
                }, onError: observer.onError(_:), onCompleted: nil, onDisposed: nil)
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .timeout(Constants.timeout, scheduler: MainScheduler.instance)
            .retry(Constants.maxCountRepeatRequest)
    }
}

