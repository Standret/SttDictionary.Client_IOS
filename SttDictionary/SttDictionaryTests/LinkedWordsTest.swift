//
//  LinkedWordsTest.swift
//  SttDictionaryTests
//
//  Created by Piter Standret on 6/17/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import XCTest
@testable import SttDictionary

class LinkedWordsTest: XCTestCase {
    
    var words: [RealmWord]!
    
    override func setUp() {
        super.setUp()
        
        words = [RealmWord]()
        words.append(RealmWord(value: ["id": "1"]))
        words.append(RealmWord(value: ["id": "2"]))
        words.append(RealmWord(value: ["id": "3"]))
        words.append(RealmWord(value: ["id": "4"]))
        words.append(RealmWord(value: ["id": "5"]))
        words.append(RealmWord(value: ["id": "6"]))
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        super.tearDown()
    }
}
