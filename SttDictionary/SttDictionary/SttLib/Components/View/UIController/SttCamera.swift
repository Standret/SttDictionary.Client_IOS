//
//  Camera.swift
//  YURT
//
//  Created by Standret on 22.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit

class SttCamera: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let picker = UIImagePickerController()
    private let callBack: (UIImage) -> Void
    private weak var parent: UIViewController?
    
    init (parent: UIViewController, handler: @escaping (UIImage) -> Void) {
        self.callBack = handler
        self.parent = parent
        super.init()
        picker.delegate = self
    }
    
    func takePhoto() {
        picker.sourceType = .camera
        parent?.present(picker, animated: true, completion: nil)
    }
    func selectPhoto() {
        picker.sourceType = .photoLibrary
        parent?.present(picker, animated: true, completion: nil)
    }
    
    func showPopuForDecision() {
        let actionController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionController.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { (x) in
            self.selectPhoto()
        }))
        actionController.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (x) in
            self.takePhoto()
        }))
        actionController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        for item in actionController.view.subviews.first!.subviews.first!.subviews {
            item.backgroundColor = UIColor.white
        }
        
        parent?.present(actionController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let _image = image?.fixOrientation() {
            callBack(_image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
