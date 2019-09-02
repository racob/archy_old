//
//  HeartRateDataRecord.swift
//  archy
//
//  Created by khoirunnisa' rizky noor fatimah on 28/08/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import Foundation
import HealthKit

let healthKitStore : HKHealthStore = HKHealthStore()

class HeartRateDataRecord {
    var timer : Timer!
    var rate : [Double] = []
    var time : [Int] = []
    var detik = 0
    
// Code ini dijalankan saat membuka apps pertama kali
//    @IBAction func authorizedTapped(_ sender: Any) {
//        authorizeHealthKitInApp()
//    }
    
// Saat practice recording dimulai
//    @IBAction func getDetailsTapped(_ sender: Any) {
//        self.startMockHeartData()
//    }
    
// Saat stop practice recording
//    @IBAction func stopHeartRate(_ sender: Any) {
//        self.stopMockHeartData()
//        print(time)
//        print(rate)
//        time = []
//        rate = []
//        detik = 0
//    }
    
    func startMockHeartData() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(subscribeToHeartBeatChanges),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func stopMockHeartData() {
        self.timer?.invalidate()
    }
    @objc func subscribeToHeartBeatChanges(){
        // Creating the sample for the heart rate
        
        guard let sampleType: HKSampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return
        }
        /// Creating an observer, so updates are received whenever HealthKit’s
        // heart rate data changes.
        HKObserverQuery.init(sampleType: sampleType, predicate: nil) { (sample, _, error) in
            self.fetchLatestHeartRateSample(completion: { (sample) in
                let heartRateUnit = HKUnit(from: "count/min")
                let hasil = sample?.quantity.doubleValue(for: heartRateUnit)
                
            })
        }
        /// When the completion is called, an other query is executed
        /// to fetch the latest heart rate
        fetchLatestHeartRateSample(completion: { sample in
            guard let sample = sample else {
                return
            }
            /// The completion in called on a background thread, but we
            /// need to update the UI on the main.
            DispatchQueue.main.async {
                /// Converting the heart rate to bpm
                let heartRateUnit = HKUnit(from: "count/min")
                let heartRate = sample
                    .quantity
                    .doubleValue(for: heartRateUnit)
                /// Updating the UI with the retrieved value
                
//                self.heartRateLabel.text = "\(Int(heartRate))"
                self.rate.append(heartRate)
                self.time.append(self.detik)
                self.detik+=1
            }
        })
    }
    
    func fetchLatestHeartRateSample(
        completion: @escaping (_ sample: HKQuantitySample?) -> Void) {
        /// Create sample type for the heart rate
        guard let sampleType = HKObjectType
            .quantityType(forIdentifier: .heartRate) else {
                completion(nil)
                return
        }
        /// Predicate for specifiying start and end dates for the query
        let predicate = HKQuery
            .predicateForSamples(
                withStart: Date.distantPast,
                end: Date(),
                options: .strictEndDate)
        /// Set sorting by date.
        let sortDescriptor = NSSortDescriptor(
            key: HKSampleSortIdentifierStartDate,
            ascending: false)
        /// Create the query
        let query = HKSampleQuery(
            sampleType: sampleType,
            predicate: predicate,
            limit: Int(HKObjectQueryNoLimit),
            sortDescriptors: [sortDescriptor]) { (_, results, error) in
                guard error == nil else {
                    print("Error: \(error!.localizedDescription)")
                    return
                }
                completion(results?[0] as? HKQuantitySample)
        }
        healthKitStore.execute(query)
    }
    
    
    func authorizeHealthKitInApp() {
        let healthKitTypesToRead : Set<HKObjectType> = [HKObjectType.quantityType(forIdentifier: .heartRate)!]
        
        let healthKitTypesToWrite : Set<HKSampleType> = []
        
        if !HKHealthStore.isHealthDataAvailable() {
            print("Error occured")
            return
        }
        
        healthKitStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) -> Void in
            print("Read Write Authorization succeded")
        }
        
    }
    
}

