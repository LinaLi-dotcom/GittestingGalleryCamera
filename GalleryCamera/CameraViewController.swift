//
//  CameraViewController.swift
//  GalleryCamera
//
//  Created by Lina Li on 2020-10-13.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var theImageView: UIImageView!
    
    var captureSession : AVCaptureSession!
    var cameraOutput : AVCapturePhotoOutput!
    var previewLayer : AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        cameraOutput = AVCapturePhotoOutput()
        
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        
        if let input = try? AVCaptureDeviceInput(device: device!){
            if (captureSession.canAddInput(input)){
                captureSession.addInput(input)
                if(captureSession.canAddOutput(cameraOutput)){
                    captureSession.addOutput(cameraOutput)
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    previewLayer.frame = previewView.bounds
                    previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    previewView.layer.addSublayer(previewLayer)
                    captureSession.startRunning()
                }
            }else{
                print("issue here : captureSession.canAddInput")
            }
             
        }else {
            print("some problem here")
        }
    }
    

    @IBAction func takePicture(_ sender: Any) {
       
        let photoSettings : AVCapturePhotoSettings!
        photoSettings = AVCapturePhotoSettings.init(format : [AVVideoCodecKey: AVVideoCodecType.jpeg])
        photoSettings.flashMode = .off
        photoSettings.isHighResolutionPhotoEnabled = false
        
        cameraOutput.capturePhoto(with: photoSettings, delegate: self)
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        let imageData = photo.fileDataRepresentation()
        let theImage = UIImage(data: imageData!)
        
        theImageView.image = theImage
    }
    
}
