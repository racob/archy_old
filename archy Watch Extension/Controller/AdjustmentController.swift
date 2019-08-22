//
//  adjustment.swift
//  archy Watch Extension
//
//  Created by Hai on 22/08/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import Foundation
import WatchKit


class AdjustmentController: WKInterfaceController {
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    @IBAction func okButton() {
//        pushController(withName: "PracticeController", context: nil)
        WKInterfaceController.reloadRootControllers(withNames: ["PracticeController"], contexts: nil)
    }
}
