//
//  BodyMeasurementController.swift
//  archy
//
//  Created by Rahmat Hidayat on 26/08/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import UIKit
import CoreMedia
import Vision
import WatchConnectivity

class BodyMeasurementController: UIViewController {

    @IBOutlet weak var jointView: DrawingJointView!
    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var imgBody: UIImageView!
    @IBOutlet weak var lblDesc: UILabel!
    
//    var connectivityHandler = WatchSessionManager.shared
    
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
    
    var modelPoint: [CapturedPoint]? = []
    var cocokIndicator : [Bool] = [false, false, false, false, false, false, false, false]
    
    enum bgBody: String {
        case begin = "measurement"
        case success = "measurement_success"
        case failed = "measurement_failed"
    }
    
    enum descBody: String {
        case begin = "Make sure your body fit inside the guidlines."
        case success = "Great! Let's take a practice!"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        connectivityHandler.iOSDelegate = self
        
        self.setUpModel()
        self.setUpCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.videoCapture.stop()
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        self.videoCapture.stop()
//    }
    
    // MARK: - Setup Core ML
    func setUpModel() {
        if let visionModel = try? VNCoreMLModel(for: EstimationModel().model) {
            self.visionModel = visionModel
            request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
            request?.imageCropAndScaleOption = .centerCrop
        } else {
            fatalError("cannot load the ml model")
        }
        
        // Data Model
        let points: [CGPoint] = [CGPoint(x: 0.49479166666666669, y: 0.38020833333333331),
                                 CGPoint(x: 0.49479166666666669, y: 0.50520833333333337),
                                 CGPoint(x: 0.578125, y: 0.50520833333333337),
                                 CGPoint(x: 0.61979166666666674, y: 0.63020833333333337),
                                 CGPoint(x: 0.66145833333333326, y: 0.75520833333333337),
                                 CGPoint(x: 0.453125, y: 0.546875),
                                 CGPoint(x: 0.41145833333333331, y: 0.671875),
                                 CGPoint(x: 0.36979166666666669, y: 0.75520833333333337)
        ]
        
        for i in 0..<points.count {
            self.modelPoint!.append(CapturedPoint.init(predictedPoint: PredictedPoint.init(maxPoint: points[i], maxConfidence: 1)))
        }
    }
    
    func setUpCamera() {
        self.videoCapture = VideoCapture()
        self.videoCapture.delegate = self
        self.videoCapture.fps = 30
        self.videoCapture.setUp(sessionPreset: .vga640x480, cameraPosition: .front) { success in
            if success {
                // add preview view on the layer
                if let previewLayer = self.videoCapture.previewLayer {
                    self.viewCamera.layer.addSublayer(previewLayer)
                    self.resizePreviewLayer()
                }
                
                // start video preview when setup is done
                self.videoCapture.start()
            }
        }
    }
    
    func resizePreviewLayer() {
        self.videoCapture.previewLayer?.frame = self.viewCamera.bounds
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        do {
////            try connectivityHandler.updateApplicationContext(applicationContext: ["state" : 7])
//        } catch {
//            print("Error: \(error)")
//        }
    }

}


// MARK: extension connectivity watchkit

//extension BodyMeasurementController: iOSDelegate {
//    
//    func applicationContextReceived(tuple: ApplicationContextReceived) {
//        DispatchQueue.main.async() {
//            if let row = tuple.applicationContext["row"] as? Int {
////                self.nextButton.backgroundColor = Constant.itemList[row].2
//            }
//        }
//    }
//    
//    
//    func messageReceived(tuple: MessageReceived) {
//        // Handle receiving message
//        
//        guard let reply = tuple.replyHandler else {
//            return
//        }
//        
//        // Need reply to counterpart
//        switch tuple.message["request"] as! RequestType.RawValue {
//        case RequestType.date.rawValue:
//            reply(["date" : "\(Date())"])
//        case RequestType.version.rawValue:
//            let version = ["version" : "\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "No version")"]
//            reply(["version" : version])
//        default:
//            break
//        }
//    }
//}

// MARK: - VideoCaptureDelegate
extension BodyMeasurementController: VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timestamp: CMTime) {
        // the captured image from camera is contained on pixelBuffer
        if let pixelBuffer = pixelBuffer {
            predictUsingVision(pixelBuffer: pixelBuffer)
        }
    }
}

extension BodyMeasurementController {
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
        
//        let matchingRatios = capturedPointsArray
//            .map { $0?.matchVector(with: predictedPoints) }
//            .compactMap { $0 }
        
        for i in 0..<self.modelPoint!.count {
            let minX = self.modelPoint![i].point.x - (self.modelPoint![i].point.x * 0.45)
            let maxX = self.modelPoint![i].point.x + (self.modelPoint![i].point.x * 0.45)
            let minY = self.modelPoint![i].point.y - (self.modelPoint![i].point.y * 0.45)
            let maxY = self.modelPoint![i].point.y + (self.modelPoint![i].point.y * 0.45)
            
            if let predicted = predictedPoints[i] {
                if predicted.maxPoint.x > minX && predicted.maxPoint.x < maxX {
                    if predicted.maxPoint.y > minY && predicted.maxPoint.y < maxY {
                        self.cocokIndicator[i] = true
                        print("cocok ke", i)
                        
                    }else{
                        self.cocokIndicator[i] = false
                    }
                }else{
                    self.cocokIndicator[i] = false
                }
                
            }
        }
        
        DispatchQueue.main.sync { [weak self] in
            guard let self = self else { return }
            if !self.cocokIndicator.contains(false) { // Bener
                print("yeay")
                self.imgBody.image = UIImage(named: bgBody.success.rawValue)
                self.lblDesc.text = descBody.success.rawValue
                self.lblDesc.textColor = Constants.colorLightBlue
                let  i = 10
//                do {
//                    try connectivityHandler.updateApplicationContext(applicationContext: ["state" : i])
//                } catch {
//                    print("Error: \(error)")
//                }
                self.videoCapture.stop()
                let vc = PoseMatchingViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false, completion: nil)
            }else{ // Salah
                self.imgBody.image = UIImage(named: bgBody.failed.rawValue)
                self.lblDesc.text = descBody.begin.rawValue
                self.lblDesc.textColor = Constants.colorRed
                
                let i = Int.random(in: 1..<3)
                
//                do {
//                    try connectivityHandler.updateApplicationContext(applicationContext: ["state" : i])
//                } catch {
//                    print("Error: \(error)")
//                }
            }
            
            // draw line
            self.jointView.bodyPoints = predictedPoints
        }
        
    }
    
}
