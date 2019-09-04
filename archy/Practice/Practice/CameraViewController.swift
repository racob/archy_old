//
//  CameraViewController.swift
//  archy
//
//  Created by Eibiel Sardjanto on 26/08/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import UIKit

protocol CameraViewDelegate {
    func startRecording()
    func stopRecording()
//    func savedVideoUrl() -> URL
}

class CameraViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet var upperViews: [UIView]!
    @IBOutlet weak var stopButton: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var delegate: CameraViewDelegate!
    
    var heartRate: HeartRateDataRecord!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpperCorner()
        buttonCountdown()
        
        self.heartRate = HeartRateDataRecord()
        self.heartRate.authorizeHealthKitInApp()
        
        // Do any additional setup after loading the view.
    }

    func setUpperCorner() {
        for upperView in upperViews {
            upperView.layer.cornerRadius = 4
        }
    }
    
    @IBAction func tapStopButton(_ sender: Any) {
        let alert = UIAlertController(title: "Want to finish practice?", message: "Your practice will be saved in the Library",         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Yes, finish",
                                      style: UIAlertAction.Style.cancel,
                                      handler: {(_: UIAlertAction!) in
                                        //finish button action
                                        self.finishPractice()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    

    func startTimer() {
        var seconds = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            seconds += 1     //This will decrement(count down)the seconds.
            self.timerLabel.text = self.timeString(time: TimeInterval(seconds))
        })
    }

    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func buttonCountdown() {
        var count = 2
        let countdown = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            if count == 0 {
                self.stopButton.setImage(UIImage(named: "stopButton.png"), for: UIControl.State.normal)
            } else {
                self.stopButton.setImage(UIImage(named: "buttonCountdown\(count).png"), for: UIControl.State.normal)
            }
            count -= 1
        })
        let invalidator = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { timer in
            countdown.invalidate()
            self.delegate.startRecording()
            self.startTimer()
            self.heartRate.startMockHeartData()
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func setHeartRate() {
//        let heartRateVC = HeartRateDataRecord()
//        heartRateVC.delegate = self
    }
    
    func finishPractice() {
        self.heartRate.stopMockHeartData()
        
        self.delegate.stopRecording()

        var idVideo = 0

        //Increment Id Video
        let currentIdVideo:Int? = UserDefaults.standard.object(forKey: userDefault.currentIdVideo.rawValue) as? Int
        if let currentId = currentIdVideo {
            idVideo = currentId + 1
        }else{
            UserDefaults.standard.set(currentIdVideo, forKey: userDefault.currentIdVideo.rawValue)
        }

        //Data Heart Rate
        let rate = self.heartRate.rate
        print("idVideo", idVideo)
        print("data rate", rate)

        //Save to Core Data
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }

        //Save Graph
        let graph = Graph(context: managedContext)
        graph.id_video = Int64(idVideo)
        graph.heart_rate = rate
//        graph.postural_sway

        //Save Library
        let currentPathVideo: String = UserDefaults.standard.object(forKey: userDefault.currentPathVideo.rawValue) as! String
        
        let currentNameVideo: String = UserDefaults.standard.object(forKey: userDefault.currentNameVideo.rawValue) as! String
        
        let currentDistanceSelected: String = UserDefaults.standard.object(forKey: userDefault.currentDistaceSelected.rawValue) as! String
        
        let library = Library(context: managedContext)
        library.id_video = Int64(idVideo)
        library.video_path = currentPathVideo
        library.name_video = currentNameVideo
        library.total_arrow = 9 //dummy
        library.created_at = Date()
        library.distance = currentDistanceSelected

        do {
            try managedContext.save()
            print("core data saved")
        } catch let err {
            print("core data NOT saved")
            print("Error : \(err)")
        }
        
        //Go to Preview
        let vc = PreviewVC()
        vc.isFromPractice = true
        vc.idVideo = String(idVideo)
        vc.dataLirabry = library
        vc.dataGraph = graph
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }

}
