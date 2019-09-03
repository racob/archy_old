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

class PracticeController: WKInterfaceController, WorkoutManagerDelegate {
    func didUpdateMotion(_ manager: WorkoutManager, posturalSway: Double) {
        DispatchQueue.main.async {
//            self.posturalSway = posturalSway
            self.instruction(instruction: posturalSway)
        }
    }
    var posturalSway: Double?
    @IBOutlet weak var timerPractice: WKInterfaceTimer!
    @IBOutlet weak var arrowPractice: WKInterfaceLabel!
    var dataPractice: [Int: [String  : Any]]?
    
    var stateArrowPostion  = true
    var arrow = 1
    func instruction(instruction: Double)  {
        if instruction == 0.0 {
            if stateArrowPostion {
                stateArrowPostion = false
                speakText(voiceOutdata: "Arrow \(String(Int(arrow))) ready to knocking")
                arrow += 1
                
            }
        }else{
            if !stateArrowPostion {
                stateArrowPostion = true
                speakText(voiceOutdata: "Ready To Shot")
                
            }
        }
    }
    let workoutManager = WorkoutManager()
//    var startTime = NSDate()
    var curentTime:Date!
    
    override init() {
        super.init()
        workoutManager.delegate = self
    }
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
//
        workoutManager.startWorkout()
//        startRecord()
    }
    
    @IBAction func finishButtohn() {
   
//        stopRecord()
        workoutManager.stopWorkout()
//        _ = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(PracticeController.sayFeedback), userInfo: nil, repeats: false)
//        alertHapticFeedback.invalidate()
//        alertHapticFeedback.
//        alertHapticFeedback = nil
        
        
        
        

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
        curentTime = Date()
        timerPractice.setDate(curentTime)
        timerPractice.start()
    }
    func stopRecord() {
        timerPractice.stop()
        
    }
    override func willActivate() {
        super.willActivate()
//        startRecord()
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
//        alertHapticFeedback = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(PracticeController.alertHaptic), userInfo: nil, repeats: true)
        
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
    func speakText(voiceOutdata: String ) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        let utterance = AVSpeechUtterance(string: voiceOutdata)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
        
        defer {
//            disableAVSession()
        }
    }
    private func disableAVSession() {
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't disable.")
        }
    }
}
