//
//  MainLeftViewController.swift
//  Instagram
//
//  Created by guanho on 2016. 10. 7..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MainLeftViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var interactor:Interactor? = nil
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageCallback(UIImagePickerControllerSourceType.camera)
    }
    
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .left)
        MenuHelper.mapGestureStateToInteractor(sender.state,progress: progress,interactor: interactor){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func closeMenu(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    //이미지 콜백
    func imageCallback(_ sourceType : UIImagePickerControllerSourceType){
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: false, completion: nil)
    }
    //이미지 끝
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    //이미지 받아오기
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var newImage: UIImage
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        dismiss(animated: false, completion: {(_) in
            
        })
    }
}
