//
//  TipsViewController.swift
//  archeryapp
//
//  Created by Eibiel Sardjanto on 17/08/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import UIKit

class TipsViewController: UIViewController {

    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIcolor()
        // Do any additional setup after loading the view.
    }
    
    func setUIcolor(){
        self.view.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.0862745098, blue: 0.2078431373, alpha: 1)
        okButton.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        okButton.layer.cornerRadius = 4
    }
    
    @IBAction func btnOkTapped(_ sender: Any) {
        let vc = BodyMeasurementController() //PoseMatchingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
