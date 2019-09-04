//
//  FinishController.swift
//  archy Watch Extension
//
//  Created by Hai on 24/08/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import Foundation
import WatchKit


class FinishController: WKInterfaceController {
    var connectivityHandler = WatchSessionManager.shared
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        
    }
    @IBAction func finishButtonTap() {
        do {
            try connectivityHandler.sendMessage(message: ["go":"blok" as AnyObject])
        } catch {
            print("Error: \(error)")
        }
    }
    override func willActivate() {
        super.willActivate()
        connectivityHandler.startSession()
        connectivityHandler.watchOSDelegate = self
    }
    @IBAction func cancel() {
        popToRootController()
    }
}
extension FinishController: WatchOSDelegate {
    func messageReceived(tuple: MessageReceived) {
    }
    
    func applicationContextReceived(tuple: ApplicationContextReceived) {
    }
    
    
}
