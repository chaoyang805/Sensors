//
//  ViewController.swift
//  Sensors
//
//  Created by chaoyang805 on 16/6/23.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import CoreMotion
class ViewController: UIViewController {

    let cmm = CMMotionManager()
    var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let image = UIImage(named: "1.jpg")
        let height = self.view.frame.height
        NSLog("image size \(image!.size)")
        let width = image!.size.width / image!.size.height * height
        
        
        NSLog("width:\(width),height:\(height)")
        
        let imageView = UIImageView(image: image)
        
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        imageView.contentMode = .ScaleAspectFill
        
        scrollView = UIScrollView()
        scrollView.addSubview(imageView)
        scrollView.frame = view.frame
        scrollView.contentSize = imageView.frame.size
        scrollView.bounces = false
        
        
        maxOffsetX = scrollView.contentSize.width - scrollView.frame.width
        view.addSubview(scrollView)
        
        
//        cmm.accelerometerUpdateInterval = 1
//        if cmm.accelerometerAvailable {
//            cmm.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) { (accData: CMAccelerometerData?, error: NSError?) in
//                NSLog("x:%.3f,y:%.3f,z:%.3f", accData!.acceleration.x, accData!.acceleration.y, accData!.acceleration.z)
//                }
//            
//        } else {
//            NSLog("accelerometer unavailable")
//        }
        
        cmm.gyroUpdateInterval = 0.02
        if cmm.gyroAvailable {
            cmm.startGyroUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (gyroData: CMGyroData?, error: NSError?) in
                
                let x = gyroData!.rotationRate.x

                // 消抖
                if abs(x) < 0.08 {
                    return
                }
                
                if self.scrollView.contentOffset.x <= 0 && x <= 0 {
                    return
                }
                
                if self.scrollView.contentOffset.x >= self.maxOffsetX && x >= 0 {
                    return
                }
                
                var offsetX = self.scrollView.contentOffset.x + CGFloat(x) * self.vecolcity
                
                if offsetX <= 0 {
                    offsetX = 0
                }
                
                if offsetX >= self.maxOffsetX {
                    offsetX = self.maxOffsetX
                }
                
                self.scrollView.contentOffset = CGPoint(x: offsetX, y: 0)
                
            })
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        cmm.stopGyroUpdates()
        cmm.stopAccelerometerUpdates()
    }
    
    let vecolcity: CGFloat = 20.0
    var maxOffsetX: CGFloat!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

