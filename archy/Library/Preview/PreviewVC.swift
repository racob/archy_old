import UIKit
import AVFoundation
import AVKit
import Charts


class PreviewVC: UIViewController, ChartViewDelegate {

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
    
    @IBOutlet weak var heartLineChartView: LineChartView!
    
    //dummy data chart
    let durationPractice = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    let bpm = [72,75,80,86,82,90,93,101,94,112,105,95]
    var posturalSway: [Bool] = [true,false,true,true,false,true,false,false,true,false,true,true]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChartView()
        
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
    
    func setChartData(durationPractice: [String],posturalSway: [Bool])
    {
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        var yVals2 : [ChartDataEntry] = [ChartDataEntry]()
      
        
        
        for i in 0..<durationPractice.count
        {
            yVals1.append(ChartDataEntry(x: Double(i), y: Double(bpm[i])))
            
            if posturalSway[i] {
               yVals2.append(ChartDataEntry(x: Double(i), y: Double(bpm[i])))
            }
        }
        
        let set1: LineChartDataSet = LineChartDataSet(entries: yVals1, label: "Heart rate (bpm)")
        set1.axisDependency = .left
        set1.setColor(UIColor.blue.withAlphaComponent(0.5))
        set1.setCircleColor(UIColor.blue)
        set1.lineWidth = 2.0
        set1.circleRadius = 6.0
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.blue
        set1.highlightColor = UIColor.white
        set1.drawCirclesEnabled = false
        set1.valueTextColor = .black
        
        let set3: LineChartDataSet = LineChartDataSet(entries: yVals2, label: "Postural sway happened")
        set3.axisDependency = .left
        set3.setColor(UIColor.red.withAlphaComponent(0.5))
        set3.setCircleColor(UIColor.red.withAlphaComponent(0.5))
        set3.lineWidth = 0
        set3.valueTextColor = .clear
        
        let data : LineChartData = LineChartData(dataSets: [set1, set3])
        data.setValueTextColor(UIColor.black)
        
        self.heartLineChartView.data = data
    }
    
    func setupChartView()
    {
        self.heartLineChartView.delegate = self
        self.heartLineChartView.gridBackgroundColor = UIColor.white
        self.heartLineChartView.noDataText = "No Data Provided"
        self.heartLineChartView.dragEnabled = true
        self.heartLineChartView.setScaleEnabled(true)
        self.heartLineChartView.pinchZoomEnabled = true
        self.heartLineChartView.animate(xAxisDuration: 2.5)
        
        setChartData(durationPractice: durationPractice, posturalSway: posturalSway)
        
    }
    
}



