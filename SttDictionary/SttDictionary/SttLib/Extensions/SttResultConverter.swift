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
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .customISO8601
                        let jsonObject = try decoder.decode(TResult.self, from: data)
                        observer.onNext(jsonObject)
                    }
                    catch {
                        print(error)
                        observer.onError(BaseError.jsonConvert("\(error)"))
                    }
                case 400:
                    observer.onError(BaseError.apiError(ApiError.badRequest((try? JSONDecoder().decode(ServiceResult.self, from: data))?.error ?? ServerError(code: 400, description: String(data: data, encoding: String.Encoding.utf8) ?? ""))))
                case 500:
                    observer.onError(BaseError.apiError(ApiError.internalServerError(String(data: data, encoding: String.Encoding.utf8) ?? "nil")))
                default:
                    observer.onError(BaseError.apiError(ApiError.otherApiError(urlResponse.statusCode)))
                }
            }, onError: { (error) in
                if let er = error as? BaseError {
                    observer.onError(er)
                }
                else {
                    observer.onError(BaseError.unkown("\(error)"))
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
                    observer.onError(BaseError.apiError(ApiError.badRequest((try? JSONDecoder().decode(ServiceResult.self, from: data))?.error ?? ServerError(code: 400, description: String(data: data, encoding: String.Encoding.utf8) ?? ""))))
                case 500:
                    observer.onError(BaseError.apiError(ApiError.internalServerError(String(data: data, encoding: String.Encoding.utf8) ?? "nil")))
                default:
                    observer.onError(BaseError.apiError(ApiError.otherApiError(urlResponse.statusCode)))
                }
            }, onError: { (error) in
                if let er = error as? BaseError {
                    observer.onError(er)
                }
                else {
                    observer.onError(BaseError.unkown("\(error)"))
                }
            }, onCompleted: nil, onDisposed: nil)
        })
    }
}
