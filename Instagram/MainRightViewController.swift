//
//  MainRightViewController.swift
//  Instagram
//
//  Created by guanho on 2016. 10. 7..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MainRightViewController: UIViewController{
    var interactor:Interactor? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .right)
        MenuHelper.mapGestureStateToInteractor(sender.state,progress: progress,interactor: interactor){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func closeMenu(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func sendAction(_ sender: AnyObject) {
        let alert = UIAlertController(title:"",message:"", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title:"사진 또는 동영상 보내기",style: .default,handler:{(_) in
            
        }))
        alert.addAction(UIAlertAction(title:"메시지 보내기",style: .default,handler:{(_) in
            
        }))
        alert.addAction(UIAlertAction(title:"취소",style: .cancel,handler:nil))
        self.present(alert, animated: true, completion: {(_) in })
    }
}
