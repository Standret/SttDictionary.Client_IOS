//
//  SttCollectionReusableView.swift
//  YURT
//
//  Created by Standret on 30.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit

class SttTCollectionReusableView<T: SttViewInjector>: UICollectionReusableView, SttViewable {
    
    var dataContext: T!
    
    func prepareBind() {
        dataContext.injectView(delegate: self)
    }
}
