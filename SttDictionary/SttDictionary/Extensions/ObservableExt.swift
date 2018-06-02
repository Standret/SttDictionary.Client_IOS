//
//  ObservableTypeExt.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

extension PrimitiveSequence {
    func toEmptyObservable<T>(ofType _: T.Type) -> Observable<T> {
        return self.asObservable().flatMap({ _ in Observable<T>.empty() })
    }
    func toObservable() -> Observable<Bool> {
        return Observable<Bool>.create({ (observer) -> Disposable in
            self.asObservable().subscribe(onCompleted: {
                observer.onNext(true)
                observer.onCompleted()
            })
        })
    }
    func inBackground() -> PrimitiveSequence<Trait, Element> {
        return self.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
    func observeInUI() -> PrimitiveSequence<Trait, Element> {
        return self.observeOn(MainScheduler.instance)
    }
}

extension Observable {
    func saveInDB(saveCallback: @escaping (_ saveCallback: Element) -> Completable) -> Observable<Element>
    {
        return self.map({ (element) -> Element in
            _ = saveCallback(element).subscribe(onCompleted: {
                Log.trace(message: "\(type(of: Element.self)) has been saved succefully in realm", key: Constants.repositoryExtensionsLog)
            }, onError: { (error) in
                Log.error(message: "\(type(of: Element.self)) could not save in db", key: Constants.repositoryExtensionsLog)
            })
            return element
        })
    }
    
    func inBackground() -> Observable<Element> {
        return self.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
    func observeInUI() -> Observable<Element> {
        return self.observeOn(MainScheduler.instance)
    }
}

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
}
