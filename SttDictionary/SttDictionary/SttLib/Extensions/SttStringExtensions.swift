//
//  SttStringExtensions.swift
//  YURT
//
//  Created by Standret on 03.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import Alamofire

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}

class SttString {
    class func isEmpty(string: String?) -> Bool {
        return (string ?? "").isEmpty
    }
    
    class func isWhiteSpace(string: String?) -> Bool {
        return (string ?? "").trimmingCharacters(in: .whitespaces).isEmpty
    }
}
