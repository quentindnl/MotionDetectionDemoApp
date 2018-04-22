//
//  ViewController.swift
//  MotionDetectionApp
//
//  Created by admin on 21/04/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import MotionDetection

class ViewController: UIViewController {

    //Start detect motion
    @IBAction func startButton(_ sender: Any) {
        let detect = Detection()
        detect.startMotionDetection()
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
    }
    
    @IBOutlet weak var myLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Update detection label
    @objc func update() {
        
        if (isRunningDownDetected==true) {myLabel.text = "Detection running Down!"}
        else {myLabel.text = "No motion detected"}
        
    }


}

