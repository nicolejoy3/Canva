//
//  CanvasViewController.swift
//  Canvas
//
//  Created by Nicole on 4/20/18.
//  Copyright © 2018 Nicole. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var trayView: UIView!
    
    var trayOriginalCenter: CGPoint!
    let trayDownOffset: CGFloat! = 170
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    var newFace: UIImageView!
    var newFaceOriginalCenter: CGPoint!
    var imageView: UIImageView!

    
    @IBOutlet weak var arrowImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        trayUp = trayView.center  // The initial position of the tray
        trayDown = CGPoint(x: trayView.center.x, y: trayView.center.y + trayDownOffset) // The position of the tray transposed down
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        
        if sender.state == .began {
            print("Gesture began")
            trayOriginalCenter = trayView.center
        } else if sender.state == .changed {
            print("Gesture is changing")
            if trayView.center.y > trayUp.y {
                trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + (translation.y / 10))
            } else  {
                trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            }
        } else if sender.state == .ended {
            print("Gesture ended")
            if velocity.y > 0 {
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [] ,animations: {
                    self.trayView.center = self.trayDown
                    self.arrowImageView.transform = self.arrowImageView.transform.rotated(by: CGFloat(Double.pi))
                })
            } else {
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [] ,animations: {
                    self.trayView.center = self.trayUp
                    self.arrowImageView.transform = self.arrowImageView.transform.rotated(by: CGFloat(Double.pi))
                })
            }
        }
    }
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            print("FaceGesture began")
            imageView = sender.view as! UIImageView
            newFace = UIImageView(image: imageView.image)
            view.addSubview(newFace)
            newFace.center = imageView.center
            newFace.center.y += trayView.frame.origin.y
            newFaceOriginalCenter = newFace.center
            newFace.transform = CGAffineTransform(scaleX: 2, y: 2)
        } else if sender.state == .changed {
            print("FaceGesture is changing")
            newFace.center = CGPoint(x: newFaceOriginalCenter.x + translation.x, y: newFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            print("FaceGesture ended")
            //add pan
            let pan_gesture = UIPanGestureRecognizer(target: self, action: #selector(didPanFaceOnTray(sender:)))
            pan_gesture.delegate = self 
            newFace.addGestureRecognizer(pan_gesture)
            //add double tap
            let double_gesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(sender:)))
            double_gesture.delegate = self
            double_gesture.numberOfTapsRequired = 2
            newFace.addGestureRecognizer(double_gesture)
            newFace.isUserInteractionEnabled = true
            //Scaling
            UIView.animate(withDuration: 0.4, animations: {
                self.newFace.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        
    }
}
    
    @objc func didPanFaceOnTray(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            //print("Began: newDidPan")
            newFace = sender.view as! UIImageView
            newFaceOriginalCenter = newFace.center
            newFace.transform = CGAffineTransform(scaleX: 2, y: 2)
        } else if sender.state == .changed {
            //print("Changed: newDidPan")
            newFace.center = CGPoint(x: newFaceOriginalCenter.x + translation.x, y: newFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            //print("Ended: newDidPan")
            UIView.animate(withDuration: 0.4, animations: {
                self.newFace.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    
    @objc func didDoubleTap(sender: UITapGestureRecognizer){
        let imageView = sender.view as! UIImageView
        imageView.removeFromSuperview()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}


