//
//  Connectivity.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import Alamofire

protocol ConnectivityDelegate {
    func connectivityChanged(status: NetworkReachabilityManager.NetworkReachabilityStatus)
}

class Conectivity {
    var delegate: ConnectivityDelegate!
    private var networkManager = NetworkReachabilityManager()
    
    var isConnected: Bool {
        return networkManager!.isReachable
    }
    
    init() {
        networkManager!.listener = {
            self.delegate?.connectivityChanged(status: $0)
        }
        networkManager?.startListening()
    }
}
