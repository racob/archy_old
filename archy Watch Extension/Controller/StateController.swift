//
//  StateController.swift
//  archy Watch Extension
//
//  Created by Hai on 24/08/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import Foundation
import WatchKit

class StateController: WKInterfaceController {
    @IBOutlet weak var imageState: WKInterfaceImage!
    @IBOutlet weak var messageState: WKInterfaceLabel!
    
    @IBOutlet weak var scnKit: WKInterfaceSCNScene!
    
    var state = false
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.scnKit = nil
//        self.scnKit.setAlpha(0)
    }
    override func willActivate() {
        super.willActivate()
        
    }
    
    func State(state: Bool) {
        if state{
            let img = UIImage(named: "Path")
            messageState.setText("Great! Let’s take a practice!")
            self.imageState.setImage(img)
            pushController(withName: "PracticeController", context: nil)
            
            self.state = false
            
        }else{
            let img = UIImage(named: "Group 2")
            messageState.setText("Make sure your body fit inside the guidelines")
            self.imageState.setImage(img)
            
            self.state = true
        }
    }
    override func didDeactivate() {
        super.didDeactivate()
        State(state: state)
        
        
    }
}
