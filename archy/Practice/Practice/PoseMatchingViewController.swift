//
//  PoseMatchingViewController.swift
//  PoseEstimation-CoreML
//
//  Created by Doyoung Gwak on 13/08/2019.
//  Copyright © 2019 tucan9389. All rights reserved.
//

import UIKit
import CoreMedia
import Vision

class PoseMatchingViewController: UIViewController {

    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var poseView: UIView!
    @IBOutlet weak var arrowIndex: UILabel!
    @IBOutlet weak var arrowView: UIView!
    
    // MARK: - UI Property
    @IBOutlet weak var videoPreview: UIView!
    @IBOutlet weak var jointView: DrawingJointView!
    @IBOutlet var capturedJointViews: [DrawingJointView]!
    @IBOutlet var capturedJointConfidenceLabels: [UILabel]!
    @IBOutlet var capturedJointBGViews: [UIView]!
    var capturedPointsArray: [[CapturedPoint?]?] = []
    var savedPointsArray: [[CapturedPoint?]?] = []
    
    var capturedIndex = 0
    var matchIndex = 0
//    let stepLabel = [
//        "Step 1",
//        "Step 2",
//        "Step 3",
//        "Step 4",
//        "Step 5"
//    ]
    // MARK: - AV Property
    var videoCapture: VideoCapture!
    
    // MARK: - ML Properties
    // Core ML model
    typealias EstimationModel = model_cpm
    
    // Preprocess and Inference
    var request: VNCoreMLRequest?
    var visionModel: VNCoreMLModel?
    
    // Postprocess
    var postProcessor: HeatmapPostProcessor = HeatmapPostProcessor()
    var mvfilters: [MovingAverageFilter] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the drawing views
        setUpCapturedJointView()

        // setup the model
        setUpModel()
        
        // setup camera
        setUpCamera()
        
        if !(UserDefaults.standard.bool(forKey: "debugMode")) {
            showUI()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        setUIproperties()
        self.videoCapture.start()
        arrowIndex.text = "1"
        
        if UserDefaults.standard.bool(forKey: "debugMode"){
            poseView.isHidden = false
        }else{
            poseView.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.videoCapture.stop()
    }
    
    func setUiOverlay() {
        // present UI overlay
        let vc = CameraViewController(nibName: "CameraViewController", bundle: nil)
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        DispatchQueue.main.async {
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    // MARK: - Setup Captured Joint View
    func setUpCapturedJointView() {
        postProcessor.onlyBust = true
        
        for capturedJointView in capturedJointViews {
            capturedJointView.layer.borderWidth = 2
            capturedJointView.layer.borderColor = UIColor.gray.cgColor
        }
        
        capturedPointsArray = capturedJointViews.map { _ in return nil }
//        loadSavedPose()
//        capturedPointsArray = savedPointsArray
        
        for currentIndex in 0..<capturedPointsArray.count {
            // retrieving a value for a key
            if let data = UserDefaults.standard.data(forKey: "points-\(currentIndex)"),
                let capturedPoints = NSKeyedUnarchiver.unarchiveObject(with: data) as? [CapturedPoint?] {
                capturedPointsArray[currentIndex] = capturedPoints
                capturedJointViews[currentIndex].bodyPoints = capturedPoints.map { capturedPoint in
                    if let capturedPoint = capturedPoint { return PredictedPoint(capturedPoint: capturedPoint) }
                    else { return nil }
                }
            }
        }
    }
    
    // MARK: - Setup Core ML
    func setUpModel() {
        if let visionModel = try? VNCoreMLModel(for: EstimationModel().model) {
            self.visionModel = visionModel
            request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
            request?.imageCropAndScaleOption = .centerCrop
        } else {
            fatalError("cannot load the ml model")
        }
    }
    
    // MARK: - SetUp Video
    func setUpCamera() {
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        videoCapture.fps = 30
        videoCapture.setUp(sessionPreset: .vga640x480, cameraPosition: .front) { success in
            
            if success {
                // add preview view on the layer
                if let previewLayer = self.videoCapture.previewLayer {
                    self.videoPreview.layer.addSublayer(previewLayer)
                    self.resizePreviewLayer()
                }
                
                // start video preview when setup is done
                self.videoCapture.start()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizePreviewLayer()
    }
    
    func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = videoPreview.bounds
    }
    
    // CAPTURE THE CURRENT POSE
    @IBAction func tapCapture(_ sender: Any) {
        let currentIndex = capturedIndex % capturedJointViews.count
        let capturedJointView = capturedJointViews[currentIndex]
        
        let predictedPoints = jointView.bodyPoints
        capturedJointView.bodyPoints = predictedPoints
        let capturedPoints: [CapturedPoint?] = predictedPoints.map { predictedPoint in
            guard let predictedPoint = predictedPoint else { return nil }
            return CapturedPoint(predictedPoint: predictedPoint)
        }
        capturedPointsArray[currentIndex] = capturedPoints
        
//        ======================================================
        var cgString: [String] = []
        for cp in capturedPoints {
            if cp?.point == nil {
                cgString.append("nil")
            }else{
                cgString.append(NSCoder.string(for: cp!.point))
            }
        }
        //print(cgString)
        print("\n=============================== Pose \(capturedIndex + 1)\n")
        
        let defaults = UserDefaults.standard
        defaults.set(cgString, forKey: "cgString\(currentIndex)")
        
        let cgPoints = defaults.object(forKey: "cgString\(currentIndex)") as? [String] ?? [String]()
        
        print(cgPoints.joined(separator: "\n"))
//        =======================================================
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: capturedPoints)
        UserDefaults.standard.set(encodedData, forKey: "points-\(currentIndex)")
        print(UserDefaults.standard.synchronize())
        
        capturedIndex += 1
    }
    
    func loadSavedPose() {
        
        savedPointsArray = Array(repeating: Array(repeating: nil, count: 14), count: 5)
        
        var points: [CGPoint] = [
             CGPoint(x: 0.53645833333333326, y: 0.171875),//0
             CGPoint(x: 0.56423611111111105, y: 0.296875),//1
             CGPoint(x: 0.53645833333333326, y: 0.33854166666666669),//2
             CGPoint(x: 0.41145833333333331, y: 0.421875),//3
             CGPoint(x: 0.3142361111111111, y: 0.50520833333333337),//4
             CGPoint(x: 0.61979166666666674, y: 0.296875),//5
             CGPoint(x: 0.703125, y: 0.44965277777777785),//6
             CGPoint(x: 0.328125, y: 0.546875),//7
                                
        ]
        
        for point in points {
            let savedPoint: CapturedPoint = CapturedPoint(point: point)
            savedPointsArray[0]?.insert(savedPoint, at: 0)
            savedPointsArray[0]?.removeLast()
        }
        var encodedData = NSKeyedArchiver.archivedData(withRootObject: savedPointsArray[0])
        UserDefaults.standard.set(encodedData, forKey: "points-\(0)")
        
        points = [  CGPoint(x: 0.71701388888888895, y: 0.13020833333333334),
                    CGPoint(x: 0.74479166666666663, y: 0.22743055555555555),
                    CGPoint(x: 0.78645833333333337, y: 0.24131944444444442),
                    CGPoint(x: 0.67534722222222232, y: 0.13020833333333334),
                    CGPoint(x: 0.50868055555555569, y: 0.15798611111111113),
                    CGPoint(x: 0.63368055555555558, y: 0.25520833333333331),
                    CGPoint(x: 0.48090277777777773, y: 0.25520833333333331),
                    CGPoint(x: 0.53645833333333337, y: 0.24131944444444442)
        ]
        
        for point in points {
            let savedPoint: CapturedPoint = CapturedPoint(point: point)
            savedPointsArray[1]?.insert(savedPoint, at: 0)
            savedPointsArray[1]?.removeLast()
        }
        encodedData = NSKeyedArchiver.archivedData(withRootObject: savedPointsArray[1])
        UserDefaults.standard.set(encodedData, forKey: "points-\(1)")
        
        points = [  CGPoint(x: 0.703125, y: 0.13020833333333334),
                    CGPoint(x: 0.71701388888888895, y: 0.50520833333333337),
                    CGPoint(x: 0.828125, y: 0.33854166666666669),
                    CGPoint(x: 0.953125, y: 0.171875),
                    CGPoint(x: 0.99479166666666663, y: 0.10243055555555557),
                    CGPoint(x: 0.578125, y: 0.33854166666666669),
                    CGPoint(x: 0.41145833333333331, y: 0.33854166666666669),
                    CGPoint(x: 0.24479166666666663, y: 0.33854166666666669)
        ]
        
        for point in points {
            let savedPoint: CapturedPoint = CapturedPoint(point: point)
            savedPointsArray[2]?.insert(savedPoint, at: 0)
            savedPointsArray[2]?.removeLast()
        }
        encodedData = NSKeyedArchiver.archivedData(withRootObject: savedPointsArray[2])
        UserDefaults.standard.set(encodedData, forKey: "points-\(2)")
        
        points = [  CGPoint(x: 0.703125, y: 0.13020833333333334),
                    CGPoint(x: 0.703125, y: 0.26909722222222215),
                    CGPoint(x: 0.80034722222222232, y: 0.296875),
                    CGPoint(x: 0.953125, y: 0.25520833333333331),
                    CGPoint(x: 0.81423611111111116, y: 0.22743055555555555),
                    CGPoint(x: 0.578125, y: 0.296875),
                    CGPoint(x: 0.43923611111111116, y: 0.33854166666666669),
                    CGPoint(x: 0.328125, y: 0.296875)
        ]
        
        for point in points {
            let savedPoint: CapturedPoint = CapturedPoint(point: point)
            savedPointsArray[3]?.insert(savedPoint, at: 0)
            savedPointsArray[3]?.removeLast()
        }
        encodedData = NSKeyedArchiver.archivedData(withRootObject: savedPointsArray[3])
        UserDefaults.standard.set(encodedData, forKey: "points-\(3)")
        
        points = [  CGPoint(x: 0.578125, y: 0.13020833333333334),
                    CGPoint(x: 0.578125, y: 0.33854166666666669),
                    CGPoint(x: 0.74479166666666663, y: 0.36631944444444442),
                    CGPoint(x: 0.81423611111111116, y: 0.57465277777777768),
                    CGPoint(x: 0.80034722222222232, y: 0.58854166666666663),
                    CGPoint(x: 0.453125, y: 0.421875),
                    CGPoint(x: 0.36979166666666669, y: 0.58854166666666663),
                    CGPoint(x: 0.27256944444444448, y: 0.72743055555555547)
        ]
        
        for point in points {
            let savedPoint: CapturedPoint = CapturedPoint(point: point)
            savedPointsArray[4]?.insert(savedPoint, at: 0)
            savedPointsArray[4]?.removeLast()
        }
        encodedData = NSKeyedArchiver.archivedData(withRootObject: savedPointsArray[4])
        UserDefaults.standard.set(encodedData, forKey: "points-\(4)")
        
    }
    
    @IBAction func tapNextButton(_ sender: Any) {
        captureButton.isHidden = true
        nextButton.isHidden = true
        showUI()
    }
    
    func showUI() {
        let vc = CameraViewController(nibName: "CameraViewController", bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        DispatchQueue.main.async {
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
    func setUIproperties(){
        for upperView in upperViews {
            upperView.layer.cornerRadius = 4
        }
        poseView.layer.cornerRadius = 6
        captureButton.layer.cornerRadius = 4
        nextButton.layer.cornerRadius = 4
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    
}

// MARK: - VideoCaptureDelegate
extension PoseMatchingViewController: VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timestamp: CMTime) {
        // the captured image from camera is contained on pixelBuffer
        if let pixelBuffer = pixelBuffer {
            predictUsingVision(pixelBuffer: pixelBuffer)
        }
    }
}

extension PoseMatchingViewController {
    // MARK: - Inferencing
    func predictUsingVision(pixelBuffer: CVPixelBuffer) {
        guard let request = request else { fatalError() }
        // vision framework configures the input size of image following our model's input configuration automatically
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
    }
    
    // MARK: - Postprocessing
    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNCoreMLFeatureValueObservation],
            let heatmaps = observations.first?.featureValue.multiArrayValue else { return }
        
        /* =================================================================== */
        /* ========================= post-processing ========================= */
        
        /* ------------------ convert heatmap to point array ----------------- */
        var predictedPoints = postProcessor.convertToPredictedPoints(from: heatmaps, isFlipped: true)
        
        /* --------------------- moving average filter ----------------------- */
        if predictedPoints.count != mvfilters.count {
            mvfilters = predictedPoints.map { _ in MovingAverageFilter(limit: 3) }
        }
        for (predictedPoint, filter) in zip(predictedPoints, mvfilters) {
            filter.add(element: predictedPoint)
        }
        predictedPoints = mvfilters.map { $0.averagedValue() }
        /* =================================================================== */
        
        let matchingRatios = capturedPointsArray
            .map { $0?.matchVector(with: predictedPoints) }
            .compactMap { $0 }
        
        /* =================================================================== */
        /* ======================= display the results ======================= */
        DispatchQueue.main.sync { [weak self] in
            guard let self = self else { return }
            
            // update arrow count every 5 pose detected
            if (matchIndex % 5) < matchingRatios.count {
                if matchingRatios[matchIndex % 5] > 0.80 {
                    print("Posematch \((matchIndex % 5) + 1)")
                    stepLabel.text = "\(matchIndex % 5 + 1)"
                    if (matchIndex % 5) == 4 {
                        print("Arrow \(String(describing: arrowIndex.text)) shot\n")
                        arrowIndex.text = "\(Int(arrowIndex.text!)! + 1)"
                    }
                    matchIndex += 1
                }
            }
            
            // draw line
            self.jointView.bodyPoints = predictedPoints
            
            var topCapturedJointBGView: UIView?
            var maxMatchingRatio: CGFloat = 0
            for (matchingRatio, (capturedJointBGView, capturedJointConfidenceLabel)) in zip(matchingRatios, zip(self.capturedJointBGViews, self.capturedJointConfidenceLabels)) {
                let text = String(format: "%.2f%", matchingRatio*100)
                capturedJointConfidenceLabel.text = text
                capturedJointBGView.backgroundColor = .clear
                if matchingRatio > 0.80 && maxMatchingRatio < matchingRatio {
                    maxMatchingRatio = matchingRatio
                    topCapturedJointBGView = capturedJointBGView
                }
            }
            topCapturedJointBGView?.backgroundColor = UIColor(red: 0.5, green: 1.0, blue: 0.5, alpha: 0.4)
        }
        /* =================================================================== */
    }
}

extension PoseMatchingViewController: CameraViewDelegate{
    
    func startRecording() {
        videoCapture.startRecording()
    }
    
    func stopRecording() {
        videoCapture.stopRecording()
        
//        let vc = PreviewVC()
//        self.present(vc, animated: true, completion: nil)
    }
    
//    func savedVideoUrl() -> URL {
//        return videoCapture.savedVideoUrl
//    }
    
}
