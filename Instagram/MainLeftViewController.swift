//
//  MainLeftViewController.swift
//  Instagram
//
//  Created by guanho on 2016. 10. 7..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import AVFoundation

class MainLeftViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var interactor:Interactor? = nil
    let picker = UIImagePickerController()
    
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        let devices = AVCaptureDevice.devices()
        for device in devices! {
            if ((device as AnyObject).hasMediaType(AVMediaTypeVideo)) {
                if((device as AnyObject).position == AVCaptureDevicePosition.back) {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        if let device = captureDevice {
                            do{
                                try device.lockForConfiguration()
                                device.focusMode = .locked
                                device.unlockForConfiguration()
                            }catch {
                                print("locaForConfiguration error")
                            }
                        }
                        do{
                            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            self.view.layer.addSublayer(previewLayer!)
                            previewLayer?.frame = self.view.layer.frame
                            captureSession.startRunning()
                        }catch{
                            print("error")
                        }
                    }
                }
            }
        }
    }
    
    let screenWidth = UIScreen.main.bounds.size.width
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let anyTouch = touches.first
        let touchPercent = (anyTouch?.location(in: self.view).x)! / screenWidth
        focusTo(value: Float(touchPercent))
    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        DispatchQueue.global().async {
//            print("moved")
//        }
//        let anyTouch = touches.first
//        let touchPercent = (anyTouch?.location(in: self.view).x)! / screenWidth
//        focusTo(value: Float(touchPercent))
//    }
    
    
    func focusTo(value : Float) {
        if let device = captureDevice {
            if(device.isLockingFocusWithCustomLensPositionSupported) {
                print(value)
                device.setFocusModeLockedWithLensPosition(value, completionHandler: { (time) in
                    print("time")
                })
                device.unlockForConfiguration()
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .left)
        MenuHelper.mapGestureStateToInteractor(sender.state,progress: progress,interactor: interactor){
            self.dismiss(animated: true, completion: nil)
        }
    }
}
