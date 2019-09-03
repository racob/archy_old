//
//  WorkoutManager.swift
//  archy Watch Extension
//
//  Created by Hai on 01/09/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import Foundation
import HealthKit

protocol WorkoutManagerDelegate: class {
    func didUpdateMotion(_ manager: WorkoutManager, posturalSway: Double)
}

class WorkoutManager: MotionManagerDelegate {
    let motionManager = MotionManager()
    
    let healtStore = HKHealthStore()
    weak var delegate: WorkoutManagerDelegate?
    var session: HKWorkoutSession?
    
    
    
    init() {
        motionManager.delegate = self
    }
    func startWorkout() {
        if session != nil {
            return
        }
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .archery
        workoutConfiguration.locationType = .outdoor
        
        do {
            session = try HKWorkoutSession(healthStore: healtStore, configuration: workoutConfiguration)
        } catch {
            fatalError("unable to create workout session!")
        }
        session?.startActivity(with: Date())
        motionManager.startUpdate()

    }
    
    func stopWorkout()  {
        if session == nil {
            return
        }
        motionManager.stopUpdates()

        session?.end()
        session = nil
        
    }
    func didUpdateMotion(_ manager: MotionManager, posturalSway: Double) {
        delegate?.didUpdateMotion(self, posturalSway: posturalSway)
    }
    
    
}
