//
//  stopcontroller.swift
//  archy Watch Extension
//
//  Created by Hai on 22/08/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import Foundation
import WatchKit

class StopController: WKInterfaceController {
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    @IBAction func finishButton() {
        pushController(withName: "FinishController", context: nil)
    }
    @IBAction func closeButton() {
        WKInterfaceController.reloadRootControllers(withNames: ["PracticeController"], contexts: nil)
//        pushController(withName: "PracticeController", context: nil)
    }
}
