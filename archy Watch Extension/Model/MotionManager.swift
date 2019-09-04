//
//  MotionManager.swift
//  archy Watch Extension
//
//  Created by Hai on 01/09/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import Foundation
import CoreMotion
import WatchKit

protocol MotionManagerDelegate: class {
    func didUpdateMotion(_ manager: MotionManager, posturalSway: Double)
}
class MotionManager {
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    let wristLocationIsLeft = WKInterfaceDevice.current().wristLocation == .left
    
    let simpleInterval = 1.0 / 50
    
    weak var delegate: MotionManagerDelegate?
    
    var postural = 0.0
    
    init() {
        queue.maxConcurrentOperationCount = 1
        queue.name = "MotionManagerQueue"
    }
/////
    func startUpdate()  {
        if !motionManager.isDeviceMotionAvailable {
            print("Device Motion is not support")
            return
        }
        
//        os_log
        motionManager.deviceMotionUpdateInterval = simpleInterval
        motionManager.startDeviceMotionUpdates(to: queue) { (deviceMotion: CMDeviceMotion?, error: Error?) in
            if error != nil {
                print("Encountered Error: \(String(describing: error))")
            }
            if deviceMotion != nil {
                self.proccesDeviceMotion(deviceMotion!)
            }
        }
    }
    
    
    /////
    func stopUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.stopDeviceMotionUpdates()
        }
    }
/////
    func proccesDeviceMotion(_ deviceMotion: CMDeviceMotion) {
        postural = {
            let data: Double = deviceMotion.gravity.x
            if data >= -0.3 && data <= 0.3 {
                let posturalswy =  abs(deviceMotion.userAcceleration.x)+abs(deviceMotion.userAcceleration.y)+abs(deviceMotion.userAcceleration.z)
//                print(deviceMot)
                return posturalswy
            }
            return 0.0
        }()
        
        updateMatricDelegate()
    }
    
    func updateMatricDelegate() {
        delegate?.didUpdateMotion(self, posturalSway: postural)
    }
    
}
