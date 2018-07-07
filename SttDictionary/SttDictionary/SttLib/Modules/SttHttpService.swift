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
        SttLog.trace(message: url, key: Constants.httpKeyLog)
        var _insertToken = insertToken
        
        if !self.connectivity.isConnected {
            sleep(Constants.timeWaitNextRequest)
            return Observable<(HTTPURLResponse, Data)>.error(SttBaseError.connectionError(SttConnectionError.noInternetConnection))
        }
            
        if self.token == "" {
            _insertToken = false
        }
        return requestData(.get, url, parameters: data, encoding: URLEncoding.default,
                           headers: _insertToken ? ["Authorization" : "\(self.tokenType) \(self.token)"] : nil)
            .configurateParamet()
    }
    
    // if key parametr is empty string and parametr is simple type, its will be insert in raw body
    // TODO: -- write handler for check if value empty key is simpleType
    func post(controller: ApiConroller, data: [String:String], insertToken: Bool) -> Observable<(HTTPURLResponse, Data)> {
        let url = "\(self.url!)\(controller.get())"
        SttLog.trace(message: url, key: Constants.httpKeyLog)
        var _insertToken = insertToken
        
        if !self.connectivity.isConnected {
            return Observable<(HTTPURLResponse, Data)>.error(SttBaseError.connectionError(SttConnectionError.noInternetConnection))
        }
        
        if self.token == "" {
            _insertToken = false
        }

        return requestData(.post, url, parameters: data, encoding: URLEncoding.httpBody,
                           headers: _insertToken ? ["Authorization" : "\(self.tokenType) \(self.token)"] : nil)
            .configurateParamet()
    }
    
    func post(controller: ApiConroller, data: Encodable?, insertToken: Bool) -> Observable<(HTTPURLResponse, Data)> {
        let url = "\(self.url!)\(controller.get())"
        SttLog.trace(message: url, key: Constants.httpKeyLog)
        var _insertToken = insertToken
        
        if !self.connectivity.isConnected {
            return Observable<(HTTPURLResponse, Data)>.error(SttBaseError.connectionError(SttConnectionError.noInternetConnection))
        }
            
        if self.token == "" {
            _insertToken = false
        }
            
            
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.timeoutInterval = TimeInterval(Constants.timeout)
        
        request.httpBody = (data?.getJsonString().data(using: .utf8, allowLossyConversion: false))
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if _insertToken {
            request.setValue("\(self.tokenType) \(self.token)", forHTTPHeaderField: "Authorization")
        }
        
        return requestData(request)
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
            
            Alamofire.upload(multipartFormData: { multipartFormData in
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
            .observeOn(SttScheduler.background)
            .timeout(Constants.timeout, scheduler: MainScheduler.instance)
            .retry(Constants.maxCountRepeatRequest)
    }
}


