//
//  SttHttpServiceTypeExtensions.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/22/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

extension SttHttpServiceType {
    func get(controller: ApiConroller, data: [String:String] = [:], insertToken: Bool = false) -> Observable<(HTTPURLResponse, Data)> {
        return self.get(controller: controller, data: data, insertToken: insertToken)
    }
    func post(controller: ApiConroller, data: [String:String] = [:], insertToken: Bool = false) -> Observable<(HTTPURLResponse, Data)> {
        return self.post(controller: controller, data: data, insertToken: insertToken)
    }
    func post(controller: ApiConroller, data: Encodable? = nil, insertToken: Bool = false) -> Observable<(HTTPURLResponse, Data)> {
        return self.post(controller: controller, data: data, insertToken: insertToken)
    }
}
