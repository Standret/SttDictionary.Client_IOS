//
//  ObservableTypeExt.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
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
                        observer.onError(ApiError.jsonConvertError)
                    }
                case 400:
                    observer.onError(ApiError.badRequest((try? JSONDecoder().decode(ServiceResult.self, from: data))?.error ?? "error parse data"))
                case 500:
                    observer.onError(ApiError.internalServerError(String(data: data, encoding: String.Encoding.utf8) ?? "error parse content"))
                default:
                    observer.onError(ApiError.unkownApiError(urlResponse.statusCode))
                }
            }, onError: { (error) in
                if let er = error as? ApiError {
                    observer.onError(er)
                }
                else {
                    observer.onError(ApiError.unkownApiError(-1))
                }
            }, onCompleted: nil, onDisposed: nil)
        })
    }
}
