////
////  CameraController.swift
////  Que Dice
////
////  Created by Michelle Cueva on 11/9/19.
////  Copyright © 2019 Michelle Cueva. All rights reserved.
////
//
//import Foundation
//import AVFoundation
//import UIKit
//import FirebaseMLVisionObjectDetection
//
//class CameraController: NSObject {
//    var captureSession: AVCaptureSession?
//    var frontCamera: AVCaptureDevice?
//    var rearCamera: AVCaptureDevice?
//    var currentCameraPosition: CameraPosition?
//    var frontCameraInput: AVCaptureDeviceInput?
//    var rearCameraInput: AVCaptureDeviceInput?
//    var photoOutput: AVCapturePhotoOutput?
//    var previewLayer: AVCaptureVideoPreviewLayer?
//    private var lastFrame: CMSampleBuffer?
//    private var isUsingFrontCamera = true
//    private var previewLayer: AVCaptureVideoPreviewLayer!
//    
//    
//    private lazy var previewOverlayView: UIImageView = {
//
//      precondition(isViewLoaded)
//      let previewOverlayView = UIImageView(frame: .zero)
//      previewOverlayView.contentMode = UIView.ContentMode.scaleAspectFill
//      previewOverlayView.translatesAutoresizingMaskIntoConstraints = false
//      return previewOverlayView
//    }()
//
//    
//    
//    
//    func prepare(completionHandler: @escaping (Error?) -> Void) {
//        func createCaptureSession() {
//            self.captureSession = AVCaptureSession()
//        }
//          func configureCaptureDevices() throws {
//            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
//            let cameras = (session.devices.compactMap { $0 })
//             
//            //2
//            for camera in cameras {
//                if camera.position == .front {
//                    self.frontCamera = camera
//                }
//             
//                if camera.position == .back {
//                    self.rearCamera = camera
//             
//                    try camera.lockForConfiguration()
//                    camera.focusMode = .continuousAutoFocus
//                    camera.unlockForConfiguration()
//                }
//            }
//        }
//          func configureDeviceInputs() throws {
//            
//            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
//            
//               //4
//               if let rearCamera = self.rearCamera {
//                   self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
//            
//                   if captureSession.canAddInput(self.rearCameraInput!) { captureSession.addInput(self.rearCameraInput!) }
//            
//                   self.currentCameraPosition = .rear
//                
//               }
//            
//               else if let frontCamera = self.frontCamera {
//                   self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
//            
//                   if captureSession.canAddInput(self.frontCameraInput!) { captureSession.addInput(self.frontCameraInput!) }
//                   else { throw CameraControllerError.inputsAreInvalid }
//            
//                   self.currentCameraPosition = .front
//                
//               }
//            
//               else { throw CameraControllerError.noCamerasAvailable }
//        }
//          func configurePhotoOutput() throws {
//            
//            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
//
//               self.photoOutput = AVCapturePhotoOutput()
//            
//            //changed things here
//            
//            guard let currentOutput = self.photoOutput else {
//                print("no photo Output")
//                return
//            }
//            
//            currentOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
//
//                if captureSession.canAddOutput(currentOutput) {
//                    captureSession.addOutput(currentOutput)
//                }
//
//               captureSession.startRunning()
//        }
//        
//        DispatchQueue(label: "prepare").async {
//              do {
//                  createCaptureSession()
//                  try configureCaptureDevices()
//                  try configureDeviceInputs()
//                  try configurePhotoOutput()
//              }
//                  
//              catch {
//                  DispatchQueue.main.async {
//                      completionHandler(error)
//                  }
//                  
//                  return
//              }
//              
//              DispatchQueue.main.async {
//                  completionHandler(nil)
//              }
//          }
//    }
//    
//    func displayPreview(on view: UIView) throws {
//        guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
//        
//           self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        self.previewLayer?.videoGravity = .resizeAspectFill
//           self.previewLayer?.connection?.videoOrientation = .portrait
//        
//           view.layer.insertSublayer(self.previewLayer!, at: 0)
//           self.previewLayer?.frame = view.frame
//    }
//    
//    private func detectObjectsOnDevice(
//      in image: VisionImage,
//      width: CGFloat,
//      height: CGFloat,
//      options: VisionObjectDetectorOptions
//    ) {
//        
//        let options = VisionObjectDetectorOptions()
//        options.detectorMode = .stream
//        options.shouldEnableMultipleObjects = false
//        options.shouldEnableClassification = true  // Optional
//
//
//        let detector = Vision.vision().objectDetector(options: options)
//
//      var detectedObjects: [VisionObject]? = nil
//      do {
//        detectedObjects = try detector.results(in: image)
//      } catch let error {
//        print("Failed to detect object with error: \(error.localizedDescription).")
//        return
//      }
//      guard let objects = detectedObjects, !objects.isEmpty else {
//        print("On-Device object detector returned no results.")
//        DispatchQueue.main.sync {
//          self.updatePreviewOverlayView()
//          self.removeDetectionAnnotations()
//        }
//        return
//      }
//
//      DispatchQueue.main.sync {
//        self.updatePreviewOverlayView()
//        self.removeDetectionAnnotations()
//        for object in objects {
//          let normalizedRect = CGRect(
//            x: object.frame.origin.x / width,
//            y: object.frame.origin.y / height,
//            width: object.frame.size.width / width,
//            height: object.frame.size.height / height
//          )
//          let standardizedRect = self.previewLayer.layerRectConverted(
//            fromMetadataOutputRect: normalizedRect).standardized
//            UIUtilities.addRectangle(
//                standardizedRect,
//                to: self.annotationOverlayView,
//                color: UIColor.green
//            )
//          let label = UILabel(frame: standardizedRect)
//          label.numberOfLines = 2
//          var description = ""
//          if let trackingID = object.trackingID {
//            description = "ID:" + trackingID.stringValue + "\n"
//          }
//          description = description + " Class:\(object.classificationCategory.rawValue)"
//          label.text = description
//
//          label.adjustsFontSizeToFitWidth = true
//          self.annotationOverlayView.addSubview(label)
//        }
//      }
//    }
//    
//    private func updatePreviewOverlayView() {
//      guard let lastFrame = lastFrame,
//        let imageBuffer = CMSampleBufferGetImageBuffer(lastFrame)
//      else {
//        return
//      }
//      let ciImage = CIImage(cvPixelBuffer: imageBuffer)
//      let context = CIContext(options: nil)
//      guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
//        return
//      }
//      let rotatedImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: .right)
//      if isUsingFrontCamera {
//        guard let rotatedCGImage = rotatedImage.cgImage else {
//          return
//        }
//        let mirroredImage = UIImage(
//           cgImage: rotatedCGImage, scale: 1.0, orientation: .leftMirrored)
//        previewOverlayView.image = mirroredImage
//      } else {
//        previewOverlayView.image = rotatedImage
//      }
//    }
//
//    private func removeDetectionAnnotations() {
//      for annotationView in annotationOverlayView.subviews {
//        annotationView.removeFromSuperview()
//      }
//    }
//    
//    
//}
//
//
//extension CameraController {
//    enum CameraControllerError: Swift.Error {
//        case captureSessionAlreadyRunning
//        case captureSessionIsMissing
//        case inputsAreInvalid
//        case invalidOperation
//        case noCamerasAvailable
//        case unknown
//    }
//
//    public enum CameraPosition {
//        case front
//        case rear
//    }
//}
//
//
//extension CameraController: AVCaptureVideoDataOutputSampleBufferDelegate {
//
//  func captureOutput(
//    _ output: AVCaptureOutput,
//    sampleBuffer: CMSampleBuffer,
//    from connection: AVCaptureConnection
//  ) {
//    guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
//      print("Failed to get image buffer from sample buffer.")
//      return
//    }
//    lastFrame = sampleBuffer
//    let visionImage = VisionImage(buffer: sampleBuffer)
//    let metadata = VisionImageMetadata()
//    let orientation = UIUtilities.imageOrientation(
//      fromDevicePosition: isUsingFrontCamera ? .front : .back
//    )
//    let visionOrientation = UIUtilities.visionImageOrientation(from: orientation)
//    metadata.orientation = visionOrientation
//    visionImage.metadata = metadata
//    let imageWidth = CGFloat(CVPixelBufferGetWidth(imageBuffer))
//    let imageHeight = CGFloat(CVPixelBufferGetHeight(imageBuffer))
//    var shouldEnableClassification = false
//    var shouldEnableMultipleObjects = false
//
//
//      let options = VisionObjectDetectorOptions()
//      options.shouldEnableClassification = shouldEnableClassification
//      options.shouldEnableMultipleObjects = shouldEnableMultipleObjects
//      options.detectorMode = .stream
//      detectObjectsOnDevice(
//        in: visionImage,
//        width: imageWidth,
//        height: imageHeight,
//        options: options)
//    }
//}
//
