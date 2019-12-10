

import AVFoundation
import CoreVideo
import FirebaseMLNLTranslate
import Firebase

@objc(CameraViewController)
class CameraViewController: UIViewController {
    
    var myQueue = Queue()
    
    
    private var currentDetector: Detector = .onDeviceText
    private var isUsingFrontCamera = true
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private lazy var captureSession = AVCaptureSession()
    private lazy var sessionQueue = DispatchQueue(label: Constant.sessionQueueLabel)
    private lazy var vision = Vision.vision()
    private var lastFrame: CMSampleBuffer?
    var stopTranslating = false
    
    var spanishEnglishTranslator: Translator!
    let localModels = ModelManager.modelManager().downloadedTranslateModels
    
    
    
    private lazy var previewOverlayView: UIImageView = {
        
        precondition(isViewLoaded)
        let previewOverlayView = UIImageView(frame: .zero)
        previewOverlayView.contentMode = UIView.ContentMode.scaleAspectFill
        previewOverlayView.translatesAutoresizingMaskIntoConstraints = false
        return previewOverlayView
    }()
    
    private lazy var annotationOverlayView: UIView = {
        precondition(isViewLoaded)
        let annotationOverlayView = UIView(frame: .zero)
        annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
        return annotationOverlayView
    }()
    
    // MARK: - IBOutlets
    
    lazy var cameraView: UIView = {
        let view = UIView(frame: self.view.frame)
        return view
    }()
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(cameraView)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        setUpPreviewOverlayView()
        setUpAnnotationOverlayView()
        setUpCaptureSessionOutput()
        setUpCaptureSessionInput()
        
        let options = TranslatorOptions(sourceLanguage: .es, targetLanguage: .en)
        spanishEnglishTranslator = NaturalLanguage.naturalLanguage().translator(options: options)
        
        // Download the French model.
        let esModel = TranslateRemoteModel.translateRemoteModel(language: .es)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewLayer.frame = cameraView.frame
    }
    
    // MARK: - IBActions
    
    //  @IBAction func switchCamera(_ sender: Any) {
    //    isUsingFrontCamera = !isUsingFrontCamera
    //    removeDetectionAnnotations()
    //    setUpCaptureSessionInput()
    //  }
    
    // MARK: - On-Device AutoML Detections
    
    
    private func recognizeTextOnDevice(in image: VisionImage, width: CGFloat, height: CGFloat) {
        
        let textRecognizer = vision.onDeviceTextRecognizer()
        textRecognizer.process(image) { text, error in
            self.removeDetectionAnnotations()
            self.updatePreviewOverlayView()
            guard error == nil, let text = text else {
                return
            }
            // Blocks.
            for block in text.blocks {
                let points = self.convertedPoints(from: block.cornerPoints, width: width, height: height)
                
                UIUtilities.addShape(
                    withPoints: points,
                    to: self.annotationOverlayView,
                    color: UIColor.purple
                )
                
                
                
                // Lines.
                for line in block.lines {
                    let points = self.convertedPoints(from: line.cornerPoints, width: width, height: height)
                    
                    UIUtilities.addShape(
                        withPoints: points,
                        to: self.annotationOverlayView,
                        color: UIColor.orange
                    )
                    
                    
                    let normalizedRect = CGRect(
                        x: line.frame.origin.x / width,
                        y: line.frame.origin.y / height,
                        width: line.frame.size.width / width,
                        height: line.frame.size.height / height
                    )
                    let convertedRect = self.previewLayer.layerRectConverted(
                        fromMetadataOutputRect: normalizedRect
                    )
                    UIUtilities.addRectangle(
                        convertedRect,
                        to: self.annotationOverlayView,
                        color: UIColor.green
                    )
                    
                    
                    //            let label = UILabel(frame: convertedRect)
                    //            label.text = element.text
                    //            label.adjustsFontSizeToFitWidth = true
                    //            self.annotationOverlayView.addSubview(label)
                    
                    
                    let conditions = ModelDownloadConditions(
                        allowsCellularAccess: false,
                        allowsBackgroundDownloading: true
                    )
                    self.spanishEnglishTranslator.downloadModelIfNeeded(with: conditions) { error in
                        guard error == nil else { return }
                        
                        //instead of dumbing everything. make a quue objevt and throttle it. so it only deques on an interval
                        
                        self.spanishEnglishTranslator.translate(line.text) { translatedText, error in
                            guard error == nil, let translatedText = translatedText else { return }
                            
                            self.myQueue.enqueue(element: translatedText)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                
                                let nextTranslatedText = self.myQueue.dequeue()
                                
                                if nextTranslatedText == nil {
                                    return
                                } else {
                                    
                                    let label = UILabel(frame: convertedRect)
                                    label.text = nextTranslatedText
                                    label.adjustsFontSizeToFitWidth = true
                                    
                                    self.annotationOverlayView.addSubview(label)
                                }
                                
                                
                            }
                            
                            
                            
                        }
                    }
                }
            }
        }
    }
    
    
    
    // MARK: - Private
    
    private func setUpCaptureSessionOutput() {
        sessionQueue.async {
            self.captureSession.beginConfiguration()
            // When performing latency tests to determine ideal capture settings,
            // run the app in 'release' mode to get accurate performance metrics
            self.captureSession.sessionPreset = AVCaptureSession.Preset.medium
            
            let output = AVCaptureVideoDataOutput()
            output.videoSettings = [
                (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA,
            ]
            let outputQueue = DispatchQueue(label: Constant.videoDataOutputQueueLabel)
            output.setSampleBufferDelegate(self, queue: outputQueue)
            guard self.captureSession.canAddOutput(output) else {
                print("Failed to add capture session output.")
                return
            }
            self.captureSession.addOutput(output)
            self.captureSession.commitConfiguration()
        }
    }
    
    private func setUpCaptureSessionInput() {
        sessionQueue.async {
            let cameraPosition: AVCaptureDevice.Position = .back
            guard let device = self.captureDevice(forPosition: cameraPosition) else {
                print("Failed to get capture device for camera position: \(cameraPosition)")
                return
            }
            do {
                self.captureSession.beginConfiguration()
                let currentInputs = self.captureSession.inputs
                for input in currentInputs {
                    self.captureSession.removeInput(input)
                }
                
                let input = try AVCaptureDeviceInput(device: device)
                guard self.captureSession.canAddInput(input) else {
                    print("Failed to add capture session input.")
                    return
                }
                self.captureSession.addInput(input)
                self.captureSession.commitConfiguration()
            } catch {
                print("Failed to create capture device input: \(error.localizedDescription)")
            }
        }
    }
    
    private func startSession() {
        sessionQueue.async {
            self.captureSession.startRunning()
        }
    }
    
    private func stopSession() {
        sessionQueue.async {
            self.captureSession.stopRunning()
        }
    }
    
    private func setUpPreviewOverlayView() {
        cameraView.addSubview(previewOverlayView)
        NSLayoutConstraint.activate([
            previewOverlayView.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor),
            previewOverlayView.centerYAnchor.constraint(equalTo: cameraView.centerYAnchor),
            previewOverlayView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
            previewOverlayView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
            
        ])
    }
    
    private func setUpAnnotationOverlayView() {
        cameraView.addSubview(annotationOverlayView)
        NSLayoutConstraint.activate([
            annotationOverlayView.topAnchor.constraint(equalTo: cameraView.topAnchor),
            annotationOverlayView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
            annotationOverlayView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
            annotationOverlayView.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor),
        ])
    }
    
    private func captureDevice(forPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: .unspecified
        )
        return discoverySession.devices.first { $0.position == position }
        
    }
    
    
    private func removeDetectionAnnotations() {
        for annotationView in annotationOverlayView.subviews {
            annotationView.removeFromSuperview()
        }
    }
    
    private func updatePreviewOverlayView() {
        guard let lastFrame = lastFrame,
            let imageBuffer = CMSampleBufferGetImageBuffer(lastFrame)
            else {
                return
        }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return
        }
        let rotatedImage = UIImage(cgImage: cgImage, scale: Constant.originalScale, orientation: .right)
        
        previewOverlayView.image = rotatedImage
    }
    
    private func convertedPoints(
        from points: [NSValue]?,
        width: CGFloat,
        height: CGFloat
    ) -> [NSValue]? {
        return points?.map {
            let cgPointValue = $0.cgPointValue
            let normalizedPoint = CGPoint(x: cgPointValue.x / width, y: cgPointValue.y / height)
            let cgPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: normalizedPoint)
            let value = NSValue(cgPoint: cgPoint)
            return value
        }
    }
    
}

// MARK: AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Failed to get image buffer from sample buffer.")
            return
        }
        lastFrame = sampleBuffer
        let visionImage = VisionImage(buffer: sampleBuffer)
        let metadata = VisionImageMetadata()
        let orientation = UIUtilities.imageOrientation(
            fromDevicePosition: .back
        )
        
        let visionOrientation = UIUtilities.visionImageOrientation(from: orientation)
        metadata.orientation = visionOrientation
        visionImage.metadata = metadata
        let imageWidth = CGFloat(CVPixelBufferGetWidth(imageBuffer))
        let imageHeight = CGFloat(CVPixelBufferGetHeight(imageBuffer))
        
        recognizeTextOnDevice(in: visionImage, width: imageWidth, height: imageHeight)
        
    }
}

// MARK: - Constants

public enum Detector: String {
    case onDeviceText = "On-Device Text Recognition"
}

private enum Constant {
    //static let cancelActionTitleText = "Cancel"
    static let videoDataOutputQueueLabel = "com.google.firebaseml.visiondetector.VideoDataOutputQueue"
    static let sessionQueueLabel = "com.google.firebaseml.visiondetector.SessionQueue"
    static let noResultsMessage = "No Results"
    static let originalScale: CGFloat = 1.0
}
