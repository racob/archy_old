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
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        
    }
    @IBAction func cancel() {
        popToRootController()
    }
}
