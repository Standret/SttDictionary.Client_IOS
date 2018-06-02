//
//  StudyViewController.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/2/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import UIKit

class StudyViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.layer.cornerRadius = UIConstants.cornerRadius
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
