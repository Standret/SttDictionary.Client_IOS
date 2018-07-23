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
import KeychainSwift

class Networking {
    static let sharedInstance = Networking()
    public var sessionManager: Alamofire.SessionManager // most of your web service clients will call through sessionManager
    public var backgroundSessionManager: Alamofire.SessionManager // your web services you intend to keep running when the system backgrounds your app will use this
    private init() {
        self.sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        self.backgroundSessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.background(withIdentifier: "com.lava.app.backgroundtransfer"))
    }
}

protocol SttHttpServiceType {
    var url: String! { get set }
    var token: String { get set }
    var tokenType: String { get set }
    
    func get(controller: ApiConroller, data: [String:String], insertToken: Bool) -> Observable<(HTTPURLResponse, Data)>
    func post(controller: ApiConroller, data: [String:String], insertToken: Bool) -> Observable<(HTTPURLResponse, Data)>
    func post(controller: ApiConroller, data: Encodable?, insertToken: Bool) -> Observable<(HTTPURLResponse, Data)>
    func upload(controller: ApiConroller, data: Data, parameter: [String:String], progresHandler: ((Float) -> Void)?) -> Observable<(HTTPURLResponse, Data)>
}

class SttHttpService: SttHttpServiceType {
    
    var url: String!
    var token: String = ""
    var tokenType: String = ""
    var connectivity = SttConectivity()
    
    init() {
        token = KeychainSwift().get(Constants.tokenKey) ?? ""
        tokenType = "bearer"
    }
    
    func  get(controller: ApiConroller, data: [String:String], insertToken: Bool) -> Observable<(HTTPURLResponse, Data)> {
        let url = "\(self.url!)\(controller.get())"
        var _insertToken = insertToken
        
        print("get")
        print(Thread.current)
        return Observable<(HTTPURLResponse, Data)>.create { (observer) -> Disposable in
            SttLog.trace(message: url, key: Constants.httpKeyLog)
            
            if !self.connectivity.isConnected {
                sleep(Constants.timeWaitNextRequest)
                observer.onError(SttBaseError.connectionError(SttConnectionError.noInternetConnection))
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
                }, onError:{
                    er in
                    observer.onError(er); print(er); })
            }
            .configurateParamet()
    }
    
    // if key parametr is empty string and parametr is simple type, its will be insert in raw body
    // TODO: -- write handler for check if value empty key is simpleType
    func post(controller: ApiConroller, data: [String:String], insertToken: Bool) -> Observable<(HTTPURLResponse, Data)> {
        let url = "\(self.url!)\(controller.get())"
        var _insertToken = insertToken
        
        return Observable<(HTTPURLResponse, Data)>.create { (observer) -> Disposable in
            SttLog.trace(message: url, key: Constants.httpKeyLog)
            
            if !self.connectivity.isConnected {
                sleep(Constants.timeWaitNextRequest)
                observer.onError(SttBaseError.connectionError(SttConnectionError.noInternetConnection))
                return Disposables.create()
            }
            
            if self.token == "" {
                _insertToken = false
            }

            return requestData(.post, url, parameters: data, encoding: URLEncoding.httpBody,
                               headers: _insertToken ? ["Authorization" : "\(self.tokenType) \(self.token)"] : nil)
                .subscribe(onNext: { (res, data) in
                    observer.onNext((res, data))
                    observer.onCompleted()
                }, onError: observer.onError(_:), onCompleted: nil, onDisposed: nil)
            }
            .configurateParamet()
    }
    
    func post(controller: ApiConroller, data: Encodable?, insertToken: Bool) -> Observable<(HTTPURLResponse, Data)> {
        let url = "\(self.url!)\(controller.get())"
        var _insertToken = insertToken
        
        return Observable<(HTTPURLResponse, Data)>.create { (observer) -> Disposable in
            SttLog.trace(message: url, key: Constants.httpKeyLog)
            
            if !self.connectivity.isConnected {
                sleep(Constants.timeWaitNextRequest)
                observer.onError(SttBaseError.connectionError(SttConnectionError.noInternetConnection))
                return Disposables.create()
            }
            
            if self.token == "" {
                _insertToken = false
            }
            
            
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = HTTPMethod.post.rawValue
            
            request.httpBody = (data?.getJsonString().data(using: .utf8, allowLossyConversion: false))
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if insertToken {
                request.setValue("\(self.tokenType) \(self.token)", forHTTPHeaderField: "Authorization")
            }
            
            return requestData(request)
                .subscribe(onNext: { (res, data) in
                    observer.onNext((res, data))
                    observer.onCompleted()
                }, onError: observer.onError(_:),
                   onCompleted: observer.onCompleted)
            }
            .configurateParamet()
    }
    
    func upload(controller: ApiConroller, data: Data, parameter: [String:String], progresHandler: ((Float) -> Void)?) -> Observable<(HTTPURLResponse, Data)> {
        let url = "\(self.url!)\(controller.get())"
        
        return Observable<(HTTPURLResponse, Data)>.create( { observer in
            SttLog.trace(message: url, key: Constants.httpKeyLog)
            
            if !self.connectivity.isConnected {
                sleep(Constants.timeWaitNextRequest)
                observer.onError(SttBaseError.connectionError(SttConnectionError.noInternetConnection))
                return Disposables.create()
            }
            
            Networking.sharedInstance.backgroundSessionManager.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(data, withName: "file", fileName: "file.png", mimeType: "image/png")
            }, to: url, method: .put, headers: parameter,
               encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (progress) in
                        if let handler = progresHandler {
                            handler(Float(progress.fractionCompleted))
                        }
                    })
                    
                    upload.responseData(completionHandler: { (fullData) in
                        if upload.response != nil && fullData.data != nil {
                            print("receive response")
                            observer.onNext((upload.response!, fullData.data!))
                            observer.onCompleted()
                        }
                        else {
                            observer.onError(SttBaseError.connectionError(SttConnectionError.responseIsNil))
                        }
                    })
                case .failure(let encodingError):
                    observer.onError(SttBaseError.unkown("\(encodingError)"))
                }
        })
            return Disposables.create();
        })
            .do(onDispose: {
                print("on DisposeD")
            })
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .timeout(180, scheduler: MainScheduler.instance)
            .retry(Constants.maxCountRepeatRequest)
    }
}

extension Observable {
    func configurateParamet() -> Observable<Element> {
        return self
            .timeout(Constants.timeout, scheduler: MainScheduler.instance)
            .retry(Constants.maxCountRepeatRequest)
    }
}


