//
//  ViewController.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import RxRealm
import RxSwift

class Message : Object {
    @objc dynamic var message: String = "some message"
}

class ViewController: SttViewController<ViewPresenter>, ViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL)
        let object = (try! Realm()).objects(Message.self)
        let notToken = object.observe { [weak self] (changes: RealmCollectionChange) in
            print(changes)
        }
        Observable.arrayWithChangeset(from: object)
            .subscribe(onNext: { array, changes in
                if let changes = changes {
                    // it's an update
                    print(array[changes.inserted.first!])
                    print("deleted: \(changes.deleted)")
                    print("inserted: \(changes.inserted)")
                    print("updated: \(changes.updated)")
                } else {
                    // it's the initial data
                    print(array)
                }
            })
    }

    @IBOutlet weak var tfMain: UITextField!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    
    @IBAction func buttonClick(_ sender: Any) {
        let model = Message()
        model.message = tfMain.text ?? ""
        tfMain.text = ""
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(model)
        }
    }
    
    @IBAction func get(_ sender: Any) {
        presenter.getTags()
    }
    
    @IBAction func forceGet(_ sender: Any) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

