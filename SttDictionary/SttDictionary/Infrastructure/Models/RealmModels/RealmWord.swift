//
//  RealmWord.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RealmSwift

class RealmWord: BaseRealm, RealmDecodable {
    
    typealias TTarget = WordApiModel
    
    @objc dynamic var originalWorld: String = ""
    let translations = List<RealmString>()
    let additionalTranslate = List<RealmString>()
    let imageUrls = List<RealmString>()
    let tags = List<RealmShortTag>()
    
    func deserialize() -> WordApiModel {
        return WordApiModel(id: id, dateCreated: dateCreated, originalWorld: originalWorld, translations: <#T##[String]#>, additionalTranslations: <#T##[String]?#>, tags: <#T##[ShortTagApiModel]?#>, imageUrls: <#T##[String]?#>)
    }
}
