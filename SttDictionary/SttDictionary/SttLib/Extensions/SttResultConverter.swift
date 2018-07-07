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
        return self.flatMap({ (arg) -> Observable<TResult> in
            let (urlResponse, data) = arg
            
            switch urlResponse.statusCode {
            case 200 ... 299:
                do {
                    print("--- in \(Thread.current)")
                    print(String(data: data, encoding: String.Encoding.utf8)!)
                    print("---")
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .customISO8601
                    let jsonObject = try decoder.decode(TResult.self, from: data)
                    return Observable.from([jsonObject])
                }
                catch {
                    print(error)
                    return Observable<TResult>.error(SttBaseError.jsonConvert("\(error)"))
                }
            case 400:
                return Observable<TResult>.error(SttBaseError.apiError(SttApiError.badRequest((try? JSONDecoder().decode(ServiceResult.self, from: data))?.error ?? ServerError(code: 400, description: String(data: data, encoding: String.Encoding.utf8) ?? ""))))
            case 500:
                return Observable<TResult>.error(SttBaseError.apiError(SttApiError.internalServerError(String(data: data, encoding: String.Encoding.utf8) ?? "nil")))
            default:
                return Observable<TResult>.error(SttBaseError.apiError(SttApiError.otherApiError(urlResponse.statusCode)))
            }
        }).catchError({ (oldError) -> Observable<TResult> in
            if let er = oldError as? SttBaseError {
                throw er
            }
            else {
                throw SttBaseError.unkown("\(oldError)")
            }
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
