import UIKit
import AVFoundation
import AVKit


class PreviewVC: UIViewController {

    var playerController = AVPlayerViewController()
    var player: AVPlayer?
    var totalScore = ""
    var totalArrow = 40
    
    @IBAction func playVideoButton(_ sender: Any) {
        playVideo()
    }
    
    @IBOutlet var totalScoreLabel: UILabel!
    
    @IBOutlet var averageScoreLabel: UILabel!
    
    @IBOutlet var totalArrowLabel: UILabel!
    
    @IBOutlet var dateOfVideoLabel: UILabel!
    
    @IBOutlet var timeOfVideoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        urlVideo()
        alertInputScore()
        
        
        
    }


    func urlVideo() {
        let videoString:String? = Bundle.main.path(forResource:"videoarcher2", ofType: ".MOV")
        
        if let url = videoString {
            
            let videoURL = NSURL(fileURLWithPath: url)
            
            self.player = AVPlayer(url: videoURL as URL)
            self.playerController.player = self.player
        }
    }
    
    
    func playVideo()
    {
        self.present(self.playerController, animated: true, completion: {
            
            self.playerController.player?.play()
            
        })
    }

    func alertInputScore()
    {
      
        let alert = UIAlertController(title: "Input Your Total Score", message: "Your score will be seen in Preview", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Input your total score"
        }
        
       
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            print("Text field: \(textField!.text)")
            self.totalScore = textField?.text ?? ""
        }))

        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        
        alertWindow.makeKeyAndVisible()
        
        alertWindow.rootViewController?.present(alert, animated:true, completion: nil)
    }
    
    
    
    
//    func generateThumbnailVideo() {
//        let videoString:String? = Bundle.main.path(forResource:"videoarcher", ofType: ".mp4")
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
