//
//  MainLeftViewController.swift
//  Instagram
//
//  Created by guanho on 2016. 10. 7..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import AVFoundation

class MainLeftViewController: UIViewController{
    var interactor:Interactor? = nil
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    
    func doubleTab(_ sender: AnyObject){
        print("ddd")
        _ = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
            .map { $0 as! AVCaptureDevice }
            .filter { $0.position == .front}
            .first!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doubleTab = UITapGestureRecognizer(target: self, action: #selector(self.doubleTab(_:)))
        doubleTab.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTab)
        
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
        let touchPoint = anyTouch?.location(in: self.view)
        focusTo(point: touchPoint!, type: 0)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let anyTouch = touches.first
        let touchPoint = anyTouch?.location(in: self.view)
        focusTo(point: touchPoint!, type: 1)
    }
    
    var isFocus = false
    func focusTo(point : CGPoint, type: Int) {
        if let device = captureDevice {
            do{
                if type == 0 && isFocus == false{
                    isFocus = true
                    let touchView = UIView(frame: CGRect(origin: CGPoint(x: point.x-40, y: point.y-40), size: CGSize(width: 80, height: 80)))
                    touchView.layer.masksToBounds = false
                    touchView.layer.cornerRadius = 40
                    touchView.layer.borderColor = UIColor.gray.cgColor
                    touchView.layer.borderWidth = 1
                    touchView.clipsToBounds = true
                    self.view.addSubview(touchView)
                    
                    UIView.animate(withDuration: TimeInterval(0.5), animations: {
                        touchView.frame = CGRect(origin: CGPoint(x: point.x-20, y: point.y-20), size: CGSize(width: 40, height: 40))
                    }, completion: { (_) in
                        touchView.removeFromSuperview()
                        self.isFocus = false
                    })
                    touchView.addCornerRadiusAnimation(from: 40, to: 20, duration: CFTimeInterval(0.5))
                }
                let touchPercent = point.x / screenWidth
                try device.lockForConfiguration()
                device.setFocusModeLockedWithLensPosition(Float(touchPercent), completionHandler: { (time) in
                    
                })
                device.unlockForConfiguration()
            }catch{
                print("Touch could not be used")
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    
    
    
    
    
    
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .left)
        MenuHelper.mapGestureStateToInteractor(sender.state,progress: progress,interactor: interactor){
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension UIView
{
    func addCornerRadiusAnimation(from: CGFloat, to: CGFloat, duration: CFTimeInterval)
    {
        let animation = CABasicAnimation(keyPath:"cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        self.layer.add(animation, forKey: "cornerRadius")
        self.layer.cornerRadius = to
    }
}
