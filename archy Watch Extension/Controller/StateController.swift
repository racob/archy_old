//
//  StateController.swift
//  archy Watch Extension
//
//  Created by Hai on 24/08/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity
import AVFoundation

class StateController: WKInterfaceController {
    @IBOutlet weak var distanceLabel: WKInterfaceLabel!
    @IBOutlet weak var imageState: WKInterfaceImage!
    @IBOutlet weak var messageState: WKInterfaceLabel!
    
    @IBOutlet weak var scnKit: WKInterfaceSCNScene!
    var distance: Int!
    
    var connectivityHandler = WatchSessionManager.shared
    
    var state = false
    var dumy: String!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        
        distance  = context as? Int
        connectivityHandler.watchOSDelegate = self
        connectivityHandler.startSession()

        distanceLabel.setText("Distance(\(distance!)m)")
        
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        return [segueIdentifier]
    }
    override func willActivate() {
        super.willActivate()
        connectivityHandler.watchOSDelegate = self
        connectivityHandler.startSession()
    }
    let fail = UIImage(named: "Group 2")
    let great = UIImage(named: "Path")
    
    func State(state: Bool) {
        if state{
            
            
            
        }else{
            
            messageState.setText("Make sure your body fit inside the guidelines")
            self.imageState.setImage(fail)
            
            self.state = true
        }
    }
    
    func stateMeasure(state: Int) {

        if state == 10 {
//            _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(StateController.sayNegatifFeedback), userInfo: nil, repeats: false)
        
            
            _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(StateController.sayFeedback), userInfo: nil, repeats: false)
        }
        
        
    }
    let positif = "Sempurna, Mari Berlatih"
    let negatif = "Negatif, pastikan kamu benar"
    let synth = AVSpeechSynthesizer()
    
    @objc func sayFeedback(){
        WKInterfaceDevice.current().play(.success)
        let utterance = AVSpeechUtterance(string: positif)
        utterance.voice = AVSpeechSynthesisVoice(language: "id-ID")
        synth.speak(utterance)
        messageState.setText("Great! Let’s take a practice!")
        self.imageState.setImage(great)
        pushController(withName: "PracticeController", context: nil)
        
        self.state = false
    }
    @objc func sayNegatifFeedback(){
        WKInterfaceDevice.current().play(.failure)
        let utterance = AVSpeechUtterance(string: negatif)
        utterance.voice = AVSpeechSynthesisVoice(language: "id-ID")
        synth.speak(utterance)
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
}

extension StateController: WatchOSDelegate {
    
    func applicationContextReceived(tuple: ApplicationContextReceived) {
        DispatchQueue.main.async() {
            if let row = tuple.applicationContext["state"] as? Int {
                self.stateMeasure(state: row)
            }
        }
    }
    
    
    func messageReceived(tuple: MessageReceived) {
        DispatchQueue.main.async() {
            WKInterfaceDevice.current().play(.notification)
            if let msg = tuple.message["msg"] {
//                self.messages.append("\(msg)")
            }
        }
    }
    
}
