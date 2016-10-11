//
//  MainViewController.swift
//  Instagram
//
//  Created by guanho on 2016. 10. 6..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var direction: Direction!
    let interactor = Interactor()
    @IBOutlet var leftEdge: UIScreenEdgePanGestureRecognizer!
    @IBOutlet var rightEdge: UIScreenEdgePanGestureRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftEdge.edges = .left
        rightEdge.edges = .right
    }
    
    
    @IBAction func leftEdgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        self.direction = .right
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .right)
        MenuHelper.mapGestureStateToInteractor(sender.state,progress: progress,interactor: interactor){
            self.performSegue(withIdentifier: "mainVCLeft", sender: nil)
        }
    }
    @IBAction func rightEdgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        self.direction = .left
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .left)
        MenuHelper.mapGestureStateToInteractor(sender.state,progress: progress,interactor: interactor){
            self.performSegue(withIdentifier: "mainVCRight", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? MainLeftViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
        }
        if let destinationViewController = segue.destination as? MainRightViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
        }
    }
}

extension MainViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator(direction: self.direction)
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
