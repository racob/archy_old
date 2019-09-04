//
//  ResultController.swift
//  archy Watch Extension
//
//  Created by Hai on 24/08/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import Foundation
import WatchKit

class ResultController: WKInterfaceController {
    
    var connectivityHandler = WatchSessionManager.shared
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        connectivityHandler.startSession()
        connectivityHandler.watchOSDelegate = self
    }
    
    override func willActivate() {
        super.willActivate()
    }
    override func didDeactivate() {
        super.didDeactivate()
    }
}

extension ResultController: WatchOSDelegate {
    func messageReceived(tuple: MessageReceived) {
        
    }
    
    func applicationContextReceived(tuple: ApplicationContextReceived) {
        DispatchQueue.main.async {
            if let message = tuple.applicationContext["resultwatch"] as? String {
                WKInterfaceController.reloadRootControllers(withNames: ["HomeController"], contexts: nil)
            }
        }
    }
    
    
}
