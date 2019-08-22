//
//  practice.swift
//  archy Watch Extension
//
//  Created by Hai on 22/08/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import Foundation
import WatchKit

class PracticeController: WKInterfaceController {
    @IBOutlet weak var resultTime: WKInterfaceTimer!
    @IBOutlet weak var arrowLabel: WKInterfaceLabel!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
    }
    @IBAction func stopButton() {
        pushController(withName: "StopController", context: nil)
    }
}
