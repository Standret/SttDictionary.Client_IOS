//
//  SttResultConverter.swift
//  SttDictionary
//
//  Created by Standret on 22.06.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType where E == (HTTPURLResponse, Data) {
    func getResult<TResult: Decodable>(ofType _: TResult.Type) -> Observable<TResult> {
        return Observable<TResult>.create({ (observer) -> Disposable in
            self.subscribe(onNext: { (urlResponse, data) in
                switch urlResponse.statusCode {
                case 200 ... 299:
                    do {
                        print("---")
                        print(String(data: data, encoding: String.Encoding.utf8))
                        print("---")
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .customISO8601
                        let jsonObject = try decoder.decode(TResult.self, from: data)
                        observer.onNext(jsonObject)
                    }
                    catch {
                        print(error)
                        observer.onError(SttBaseError.jsonConvert("\(error)"))
                    }
                case 400:
                    observer.onError(SttBaseError.apiError(SttApiError.badRequest((try? JSONDecoder().decode(ServiceResult.self, from: data))?.error ?? ServerError(code: 400, description: String(data: data, encoding: String.Encoding.utf8) ?? ""))))
                case 500:
                    observer.onError(SttBaseError.apiError(SttApiError.internalServerError(String(data: data, encoding: String.Encoding.utf8) ?? "nil")))
                default:
                    observer.onError(SttBaseError.apiError(SttApiError.otherApiError(urlResponse.statusCode)))
                }
            }, onError: { (error) in
                if let er = error as? SttBaseError {
                    observer.onError(er)
                }
                else {
                    observer.onError(SttBaseError.unkown("\(error)"))
                }
            }, onCompleted: observer.onCompleted)
        })
    }
    
    func getResult() -> Observable<Bool> {
        return Observable<Bool>.create({ (observer) -> Disposable in
            self.subscribe(onNext: { (urlResponse, data) in
                switch urlResponse.statusCode {
                case 200 ... 299:
                    observer.onNext(true)
                    observer.onCompleted()
                case 400:
                    observer.onError(SttBaseError.apiError(SttApiError.badRequest((try? JSONDecoder().decode(ServiceResult.self, from: data))?.error ?? ServerError(code: 400, description: String(data: data, encoding: String.Encoding.utf8) ?? ""))))
                case 500:
                    observer.onError(SttBaseError.apiError(SttApiError.internalServerError(String(data: data, encoding: String.Encoding.utf8) ?? "nil")))
                default:
                    observer.onError(SttBaseError.apiError(SttApiError.otherApiError(urlResponse.statusCode)))
                }
            }, onError: { (error) in
                if let er = error as? SttBaseError {
                    observer.onError(er)
                }
                else {
                    observer.onError(SttBaseError.unkown("\(error)"))
                }
            }, onCompleted: nil, onDisposed: nil)
        })
    }
}
