//
//  CameraViewController.swift
//  archy
//
//  Created by Eibiel Sardjanto on 26/08/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import UIKit
import ReplayKit

class CameraViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet var upperViews: [UIView]!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpperCorner()
        buttonCountdown()
        
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
                                        let vc = PreviewVC(nibName: "PreviewVC", bundle: nil)
                                        vc.modalPresentationStyle = .currentContext
                                        self.present(vc, animated: true, completion: nil)
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
            self.startTimer()
        })
    }
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        dismiss(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
