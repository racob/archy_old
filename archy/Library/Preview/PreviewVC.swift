import UIKit
import AVFoundation
import AVKit


class PreviewVC: UIViewController {

    var playerController = AVPlayerViewController()
    var player: AVPlayer?
    var totalScore = 0
    var totalArrow = 40
    var isFromPractice = false
    
    @IBAction func playVideoButton(_ sender: Any) {
        playVideo()
    }
    
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet var totalScoreLabel: UILabel!
    
    @IBOutlet var averageScoreLabel: UILabel!
    
    @IBOutlet var totalArrowLabel: UILabel!
    
    @IBOutlet var dateOfVideoLabel: UILabel!
    
    @IBOutlet var timeOfVideoLabel: UILabel!
    
    @IBOutlet weak var posturalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Preview"
        
        urlVideo()
        if self.isFromPractice {
            alertInputScore()
        }
        
        totalArrowLabel.text = "of " + "\(totalArrow)" + " arrows"
    }


    func urlVideo() {
        let videoString:String? = Bundle.main.path(forResource:"videoarcher2", ofType: ".MOV")
        
        if let url = videoString {
            let videoURL = NSURL(fileURLWithPath: url)
            
            self.player = AVPlayer(url: videoURL as URL)
            self.playerController.player = self.player
            
            self.imgThumbnail.setupPreview(withPath: videoString!)
        }
    }
    
    
    func playVideo() {
        self.present(self.playerController, animated: true, completion: {
            self.playerController.player?.play()
        })
    }

    func alertInputScore() {
        let alert = UIAlertController(title: "Input Your Total Score", message: "Your score will be seen in Preview", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Input your total score"
        }
        
       
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            print("Text field: \(textField!.text)")
            self.totalScore = Int(textField?.text ?? "")!
            self.totalScoreLabel.text = "\(self.totalScore)"
            self.averageScoreCount()
        }))

        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        
        alertWindow.makeKeyAndVisible()
        
        alertWindow.rootViewController?.present(alert, animated:true, completion: nil)
    }
    
    func averageScoreCount() {
        let averageScore: Double = Double(totalScore) / Double(totalArrow)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .up
        
        let averageScoreRounded = String(describing: formatter.string(from: NSNumber(value: averageScore)))
        
        averageScoreLabel.text  = averageScoreRounded
    }
    
//    func generateThumbnailVideo() {
//        let videoString:String? = Bundle.main.path(forResource:"videoarcher2", ofType: ".MOV")
//
//        if let url = videoString {
//            let fileUrl = URL(fileURLWithPath: url)
//            var avAsset = AVURLAsset(url: fileUrl, options: nil)
//            var imageGenerator = AVAssetImageGenerator(asset: avAsset)
//            imageGenerator.appliesPreferredTrackTransform = true
//            var thumbnail: UIImage?
//
//            do {
//                thumbnail = try UIImage(cgImage: imageGenerator.copyCGImage(at: CMTime(seconds: 0, preferredTimescale: 1), actualTime: nil))
//
//
//              self.videoThumbnail.image = thumbnail!
//            } catch let e as NSError {
//                print("Error: \(e.localizedDescription)")
//            }
//        }
//    }
    
}
