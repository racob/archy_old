//
//  SetDistanceViewController.swift
//  archeryapp
//
//  Created by Eibiel Sardjanto on 17/08/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import UIKit

class SetDistanceViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var distancePicker: UIPickerView!
    var pickerData: [String] = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUIcolor()
        
        // Connect data:
        self.distancePicker.delegate = self
        self.distancePicker.dataSource = self
        
        // Input the data into the array
        pickerData = ["5 m", "10 m", "15 m", "20 m"]
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) ->  String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        return myTitle
    }
    
    func setUIcolor(){
        self.view.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.0862745098, blue: 0.2078431373, alpha: 1)
        nextButton.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        nextButton.layer.cornerRadius = 4
    }

    @IBAction func btnNextTapped(_ sender: UIButton) {
        self.navigationController?.pushViewController(TipsViewController(), animated: true)
    }
    
}
