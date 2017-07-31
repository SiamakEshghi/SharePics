//
//  CameraViewController.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-07-24.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate {
    
    
    //MARK: -PROPERTIES
    let captureSession = AVCaptureSession()
    var previewLayer:CALayer! = nil
    var captureDevice: AVCaptureDevice!
    var eventId: String?
    
    var takePhoto = false
    
    //MARK: -OUTLETS AND ACTIONS
    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
        takePhoto = true
    }
    
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
      
        }

    override func viewWillAppear(_ animated: Bool) {
        prepareCamera()
    }
    

    //MARK: - PREAPARE CAMERA
    func prepareCamera()  {
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        if let availableDevices = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .back).devices{
            captureDevice = availableDevices.first
            beginSession()
        }
    }
    
    //MARK: -BEGIN SESSION
    func beginSession () {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession.addInput(captureDeviceInput)
            
        }catch {
            print(error.localizedDescription)
        }
        if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
            self.previewLayer = previewLayer
            self.view.layer.addSublayer(self.previewLayer)
            self.previewLayer.frame = self.view.layer.frame
            captureSession.startRunning()
            
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString):NSNumber(value:kCVPixelFormatType_32BGRA)]
            
            dataOutput.alwaysDiscardsLateVideoFrames = true
            
            if captureSession.canAddOutput(dataOutput) {
                captureSession.addOutput(dataOutput)
            }
            
            captureSession.commitConfiguration()
            
            
            let queue = DispatchQueue(label: "com.ASJ.captureQueue")
            dataOutput.setSampleBufferDelegate(self , queue: queue)
            
        }
        
    }
    
    //MARK: -CAPTURE OUTPUT
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
        if takePhoto {
            takePhoto = false
            
            if let image = self.getImageFromSampleBuffer(buffer: sampleBuffer) {
                
                let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as! PhotoViewController
                
                photoVC.takenPhoto = image
                photoVC.eventId = self.eventId
                DispatchQueue.main.async {
                    self.present(photoVC, animated: true, completion: {
                        self.stopCaptureSession()
                    })
                    
                }
            }
            
        }
    }
    
    //MARK: -GETIMAGEFROMSAMPLEBUFFER
    func getImageFromSampleBuffer (buffer:CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            
            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
            
        }
        
        return nil
    }
    
    //MARK: -STOPCAPTURESESSION
    func stopCaptureSession () {
        self.captureSession.stopRunning()
        
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                self.captureSession.removeInput(input)
            }
        }
        
    }
    

}
