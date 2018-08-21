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
    @objc dynamic var secondMessage: String = "some message"
}

class ViewController: SttViewController<ViewPresenter>, ViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
       
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
        let object = realm.objects(Message.self)[0]
        try! realm.write {
            //realm.add(model)
            update(mess: object, str: model.message)
        }
    }
    
    func update(mess: Message, str: String) {
        mess.message = str
        //mess.secondMessage = str
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

