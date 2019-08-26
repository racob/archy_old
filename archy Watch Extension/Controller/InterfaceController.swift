//
//  InterfaceController.swift
//  archy Watch Extension
//
//  Created by Hai on 21/08/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var scnKit: WKInterfaceSCNScene!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        self.scnKit.scene = nil
        self.scnKit.setAlpha(0)
        
    }
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
//        pushController(withName: "StateController", context: nil)
        WKInterfaceController.reloadRootControllers(withNames: ["StateController"], contexts: nil)
    }
    
    @IBAction func distancePush() {
//        pushController(withName: "DistanceController", context: nil)
    }
    
}
