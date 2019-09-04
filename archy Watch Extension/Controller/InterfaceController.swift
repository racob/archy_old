//
//  InterfaceController.swift
//  archy Watch Extension
//
//  Created by Hai on 21/08/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

//import WatchKit
//import Foundation
//import WatchConnectivity
//
//class InterfaceController: WKInterfaceController, WCSessionDelegate {
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
////        print(act)
//    }
//    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
////        print(applicationContext["setdistance"] as? String)
//        pushController(withName: "StateController", context: nil)
//    }
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
////        WKInterfaceController.reloadRootControllers(withNames: ["StateController"], contexts: nil)
//    }
//
//    var wcSession: WCSession!
//
//    @IBOutlet weak var scnKit: WKInterfaceSCNScene!
//    override func awake(withContext context: Any?) {
//        super.awake(withContext: context)
//
//        // Configure interface objects here.
//        self.scnKit.scene = nil
//        self.scnKit.setAlpha(0)
//
//        wcSession = WCSession.default
//        wcSession.delegate = self
//        wcSession.activate()
//
//
//
//    }
//
//
//    override func willActivate() {
//        // This method is called when watch view controller is about to be visible to user
//        super.willActivate()
//        wcSession = WCSession.default
//        wcSession.delegate = self
//        wcSession.activate()
//
//    }
//
//    override func didDeactivate() {
//        // This method is called when watch view controller is no longer visible
//        super.didDeactivate()
////        pushController(withName: "StateController", context: nil)
//        WKInterfaceController.reloadRootControllers(withNames: ["StateController"], contexts: nil)
//    }
//
//    @IBAction func distancePush() {
////        pushController(withName: "DistanceController", context: nil)
//    }
//
//}



import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {
    

    
    @IBOutlet weak var tittle: WKInterfaceLabel!
    var connectivityHandler = WatchSessionManager.shared
    var session : WCSession?
    var counter = 0

    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
//        messages.append("ready")
        

    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        connectivityHandler.startSession()
        connectivityHandler.watchOSDelegate = self
        
    }
    
    override func didDeactivate() {
        print("DEACTIVATE")
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    

    var values: Int?
    func changeTheme(value: Int) {
        if value == 5 {
            self.values = 10
        }else{
            self.values = 10
        }

        WKInterfaceController.reloadRootControllers(withNames: ["StateController"], contexts: [self.values!])

    }
    

}

extension InterfaceController: WatchOSDelegate {
    
    func applicationContextReceived(tuple: ApplicationContextReceived) {
        DispatchQueue.main.async() {
            if let row = tuple.applicationContext["row"] as? Int {
                self.changeTheme(value: row)
            }
        }
    }
    
    
    func messageReceived(tuple: MessageReceived) {
        DispatchQueue.main.async() {
            WKInterfaceDevice.current().play(.notification)
            if let msg = tuple.message["msg"] {
//                self.messages.append("\(msg)")
            }
        }
    }
    
}

