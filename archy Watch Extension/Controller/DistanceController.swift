//
//  Distance.swift
//  archy Watch Extension
//
//  Created by Hai on 21/08/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import Foundation
import WatchKit

class DistanceController: WKInterfaceController{
    
    let arraydistanceTarget = [5,10,15,20]
    var distanceSelect: Int?
    
    @IBOutlet weak var distanceTargetPicker: WKInterfacePicker!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        
        let five = WKPickerItem()
        five.title = "5 M"
        let teen = WKPickerItem()
        teen.title = "10 M"
        let fiveteen = WKPickerItem()
        fiveteen.title = "15 M"
        let twenty = WKPickerItem()
        twenty.title = "20 M"
        
        
        let targetDistance = [five,teen,fiveteen,twenty]
        distanceTargetPicker.setItems(targetDistance)
        distanceTargetPicker.setSelectedItemIndex(1)

        
    }
    
    @IBAction func pickerSelected(_ value: Int) {
        distanceSelect = arraydistanceTarget[value]
    }
    
    @IBAction func okButton() {
        print(distanceSelect!)
        
        pushController(withName: "AdjustmentController", context: nil)
//        popToRootController()
    }
    
    
}
