//
//  PracticeController.swift
//  archy Watch Extension
//
//  Created by Hai on 24/08/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import Foundation
import WatchKit
import AVFoundation

class PracticeController: WKInterfaceController {
    @IBOutlet weak var timerPractice: WKInterfaceTimer!
    @IBOutlet weak var arrowPractice: WKInterfaceLabel!
    var dataPractice: [Int: [String  : Any]]?
//    var startTime = NSDate()
    var curentTime:Date!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
//
//        let WKInterface
       
//        startRecord()
    }
    @IBAction func finishButtohn() {
        curentTime = Date()
         timerPractice.setDate(curentTime)
        timerPractice.start()
        
        
        
        
        
//        let repaet = Repeated.
        
        
//        _ = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(PracticeController.sayFeedback), userInfo: nil, repeats: false)
        alertHapticFeedback.invalidate()
//        alertHapticFeedback.
        alertHapticFeedback = nil
        
        
        
        

    }
    
    
    @objc func sayFeedback()
    {
        let string = "Tahan "
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "id-ID")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    @objc func alertHaptic()
    {
        WKInterfaceDevice.current().play(.start)
        
    }
    func startRecord() {
        timerPractice.start()
    }
    func stopRecord() {
        timerPractice.stop()
        
    }
    override func willActivate() {
        super.willActivate()
//        let textChoices = ["Yes"]
//        presentTextInputController(withSuggestions: textChoices,
//                                                  allowedInputMode: WKTextInputMode.plain,
//                                                  completion: {(results) -> Void in
//                                                    if results != nil && results!.count > 0 { //selection made
//                                                        self.alertHaptic()
//                                                    }
//        }
//        )
        
//        let voice = AVSpeechSynthesisVoice
        alertHapticFeedback = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(PracticeController.alertHaptic), userInfo: nil, repeats: true)
        
    }
    var alertHapticFeedback: Timer!
    var elapsedTime: TimeInterval = 0.0
    override func didDeactivate() {
        super.didDeactivate()
        
//        getDataPosturalSway(arraowN: 1)
    }
    func getDataPosturalSway(arraowN: Int) {
        let date = NSDate()
        elapsedTime = date.timeIntervalSince(curentTime)
        print("currentTime : \(date.timeIntervalSince(curentTime))")
        print(elapsedTime)
    }
    
}
