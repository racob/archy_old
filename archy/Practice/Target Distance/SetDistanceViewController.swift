//
//  SetDistanceViewController.swift
//  archeryapp
//
//  Created by Eibiel Sardjanto on 17/08/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import UIKit
import WatchConnectivity

class SetDistanceViewController: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var distancePicker: UIPickerView!
    var connectivityHandler = WatchSessionManager.shared
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUIcolor()
        
        connectivityHandler.iOSDelegate = self
        connectivityHandler.startSession()
        
        
        distancePicker.delegate = self
        distancePicker.dataSource = self
        
    
        distancePicker.selectedRow(inComponent: 0)
    }
    

    
    func setUIcolor(){
        self.view.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.0862745098, blue: 0.2078431373, alpha: 1)
        
//        nextButton.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        nextButton.layer.cornerRadius = 4
    }
    var counter = 10
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        
        if counter == 10 {
            counter = 5
        }else{
            counter = 10
        }
        do {
            try connectivityHandler.updateApplicationContext(applicationContext: ["row" : counter])
        } catch {
            print("Error: \(error)")
        }
        self.navigationController?.pushViewController(TipsViewController(), animated: true)
    }
    
}

extension SetDistanceViewController: iOSDelegate {
    
    func applicationContextReceived(tuple: ApplicationContextReceived) {
        DispatchQueue.main.async() {
            if let row = tuple.applicationContext["row"] as? Int {
                self.nextButton.backgroundColor = Constant.itemList[row].2
            }
        }
    }
    
    
    func messageReceived(tuple: MessageReceived) {
        // Handle receiving message
        
        guard let reply = tuple.replyHandler else {
            return
        }
        
        // Need reply to counterpart
        switch tuple.message["request"] as! RequestType.RawValue {
        case RequestType.date.rawValue:
            reply(["date" : "\(Date())"])
        case RequestType.version.rawValue:
            let version = ["version" : "\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "No version")"]
            reply(["version" : version])
        default:
            break
        }
    }
    
}
extension SetDistanceViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constant.itemList.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constant.itemList[row].1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        do {
//            try connectivityHandler.updateApplicationContext(applicationContext: ["row" : row])
//        } catch {
//            print("Error: \(error)")
//        }
        self.nextButton.backgroundColor = Constant.itemList[row].2
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = Constant.itemList[row].1
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        return myTitle
    }
}

