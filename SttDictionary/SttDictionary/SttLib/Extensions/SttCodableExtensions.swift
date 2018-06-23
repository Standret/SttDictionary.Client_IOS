//
//  CodableExtensions.swift
//  SttDictionary
//
//  Created by Standret on 25.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

extension Encodable {
    func getDictionary() -> [String:Any] {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let json = (try encoder.encode(self))
            print(String(data: json, encoding: .utf8)!)
            let jsonData = String(data: json, encoding: .utf8)?.data(using: .utf8)
            return (try JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves) as? [String:Any])!
        }
        catch {
            return [:]
        }
    }
}
