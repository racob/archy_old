import UIKit
import AVFoundation
import AVKit
import Charts


class PreviewVC: UIViewController, ChartViewDelegate {
    var connectivityHandler = WatchSessionManager.shared
    
    
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
    let posturalSway = [false, false, false, true, false, false, true, false, false, true, false, false]
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var playerController = AVPlayerViewController()
    var player: AVPlayer?
    var totalScore = 0
    var totalArrow = 40
    var isFromPractice = false //false: Library, true:Practice
    var idVideo: String!
    var dataLibrary: Library?
    var dataGraph: Graph?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectivityHandler.iOSDelegate = self
        setupChartView()
        
        self.navigationItem.title = "Preview"
        
        if self.isFromPractice {
            let btnBack: UIButton = UIButton()
            btnBack.addTarget(self, action: #selector(self.backTapped), for: UIControl.Event.touchUpInside)
            btnBack.setTitle("Close", for: .normal)
            btnBack.setTitleColor(.white, for: .normal)
            btnBack.sizeToFit()
            let barBack = UIBarButtonItem(customView: btnBack)
            self.navigationItem.leftBarButtonItem = barBack
            
            alertInputScore()
        }else{
            self.showData()
        }
    }
    
    @objc func backTapped() {
        if let _ = self.navigationController?.popViewController(animated: true) {}else{
            let home = HomeViewController()
            let nav = UINavigationController(rootViewController: home)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func alertInputScore() {
        let alert = UIAlertController(title: "Input Your Total Score", message: "Your score will be seen in Preview", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Input your total score"
            textField.keyboardType = .numberPad
        }
        
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            print("Text field: \(textField!.text)")
            self.totalScore = Int(textField?.text ?? "")!
            self.totalScoreLabel.text = "\(self.totalScore)"
            self.averageScoreCount()
            
            do{
                try self.connectivityHandler.updateApplicationContext(applicationContext: ["resultwatch":"ok"])
            }catch{
                print("Error: \(String(describing: error))")
            }
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
        
        averageScoreLabel.text = averageScoreRounded
        
        self.showData()
    }
    
    func showData() {
        
        if let library = dataLibrary {
            self.totalArrow = Int(library.total_arrow)
            self.totalArrowLabel.text = "of \(library.total_arrow) arrows"
            
            self.urlVideo(library.name_video)
        }
    }


    func urlVideo(_ videoName: String?) {
        if let name = videoName {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
            let url = URL(fileURLWithPath: documentsPath.appendingPathComponent(name)).appendingPathExtension("MOV")
            
            self.player = AVPlayer(url: url)
            self.playerController.player = self.player
            
            self.imgThumbnail.setupPreview(withPath: url.absoluteString)
        }
    }
    
    
    func playVideo() {
        self.present(self.playerController, animated: true, completion: {
            self.playerController.player?.play()
        })
    }
    
    func setChartData(durationPractice: [String], posturalSway: [Bool]) {
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        var yVals2 : [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0..<durationPractice.count
        {
            yVals1.append(ChartDataEntry(x: Double(i), y: Double(bpm[i])))
            
            if self.posturalSway[i] {
                yVals2.append(ChartDataEntry(x: Double(i), y: Double(bpm[i])))
            }
        }
        
        let set1: LineChartDataSet = LineChartDataSet(entries: yVals1, label: "Heart rate (bpm)")
        set1.axisDependency = .left
        set1.setColor(UIColor.blue.withAlphaComponent(0.5))
        set1.setCircleColor(UIColor.blue)
        set1.lineWidth = 4.0
        set1.circleRadius = 10.0
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.blue
        set1.highlightColor = UIColor.white
        set1.drawCirclesEnabled = false
        
        let set2: LineChartDataSet = LineChartDataSet(entries: yVals2, label: "Postural sway happened")
        set2.axisDependency = .left
        set2.setColor(UIColor.red.withAlphaComponent(0.5))
        set2.setCircleColor(UIColor.red.withAlphaComponent(0.5))
        set2.lineWidth = 0.0
        set2.valueTextColor = .clear
        
        let data : LineChartData = LineChartData(dataSets: [set1, set2])
      
        
        self.heartLineChartView.data = data
    }
    
    func setupChartView() {
        self.heartLineChartView.delegate = self
        self.heartLineChartView.gridBackgroundColor = UIColor.white
        self.heartLineChartView.noDataText = "No Data Provided"
        self.heartLineChartView.dragEnabled = true
        self.heartLineChartView.setScaleEnabled(true)
        self.heartLineChartView.pinchZoomEnabled = true
        self.heartLineChartView.animate(xAxisDuration: 2.5)
        
        self.setChartData(durationPractice: self.durationPractice, posturalSway: self.posturalSway)
    }
    
}
extension PreviewVC: iOSDelegate{
    func messageReceived(tuple: MessageReceived) {
        
    }
    
    func applicationContextReceived(tuple: ApplicationContextReceived) {
        
    }
    
    
}



