//
//  ViewController.swift
//  archeryapp
//
//  Created by Eibiel Sardjanto on 17/08/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import UIKit
import WatchConnectivity

class HomeViewController: UIViewController {
    
    

//    var connectivityHandler = WatchSessionManager.shared
    
    @IBOutlet weak var startPracticeButton: UIButton!
    @IBOutlet weak var textview: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        connectivityHandler.iOSDelegate = self
        
        setCustomUI()

        
        let firstAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 40)]
        let secondAttributes : [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 27)]
        
        let firstString = NSMutableAttributedString(string: "Hi, Archer!", attributes: firstAttributes)
        let secondString = NSAttributedString(string: "\nAre you ready\nto shoot?", attributes: secondAttributes)
        
        firstString.append(secondString)
        textview.attributedText = firstString
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func setCustomUI(){
        self.view.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.0862745098, blue: 0.2078431373, alpha: 1)
        startPracticeButton.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        startPracticeButton.layer.cornerRadius = 4
    }
    
    @IBAction func btnStartPracticeTapped(_ sender: UIButton) {
        self.navigationController?.pushViewController(SetDistanceViewController(), animated: true)

    }
    
    @IBAction func btnLibraryTapped(_ sender: UIButton) {
        self.navigationController?.pushViewController(AlbumsVC(), animated: true)
    }
    
}

//extension HomeViewController: iOSDelegate{
//    func applicationContextReceived(tuple: ApplicationContextReceived) {
//        print("YEY")
//        DispatchQueue.main.async() {
//            if let row = tuple.applicationContext["go"] as? String {
////                self.changeTheme(row)
//                print(row)
//            }
//        }
//    }
//
//
//    func messageReceived(tuple: MessageReceived) {
//        DispatchQueue.main.async() {
////            WKInterfaceDevice.current().play(.notification)
//            if let msg = tuple.message["go"] {
////                self.messages.append("\(msg)")
//                print(msg)
//            }
//        }
//    }
//}
