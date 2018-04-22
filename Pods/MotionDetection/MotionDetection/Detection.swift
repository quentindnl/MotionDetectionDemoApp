//
//  Detection.swift
//  MotionDetection
//
//  Created by admin on 21/04/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit

public var isRunningDownDetected = false
public var isRunningUpDetected = false
public var isRunningUpDownDetected = false
public var isRunningDownUpDetected = false
public var bicepCurlCounter = 0
public var starJumpCounter = 0
public var currentBrightness = CGFloat(0.0)
public var isDeviceInPocket = false


public class Detection {
    
    public init() {}
    
    public var altimeter: CMAltimeter!
    public var motion = CMMotionManager()
    public var altitude = 0.0
    public var deltaAltitude = 0.0
    
    public var accX = 0.0
    public var accY = 0.0
    public var accZ = 0.0
    public var accMax = 0.0
    public var accMin = 0.0
    
    //INIT Variables
    public func initVariables() {
        
        altitude = 0.0
        deltaAltitude = 0.0
        
        isRunningDownDetected = false
        isRunningUpDetected = false
        isRunningUpDownDetected = false
        isRunningDownUpDetected = false
        isDeviceInPocket = false
        
        bicepCurlCounter = 0
        starJumpCounter = 0
        
    }
    
    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------
    //SENSOR
    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------
    
    
    //START sensors and motion detection
    public func startMotionDetection() {
        initVariables()
        startBarometer()
        startAccelerometer()
    }
    
    //STOP sensors, motion detection and reinit variables
    public func stopMotionDetection() {
        stopBarometer()
        stopAccelerometer()
    }
    
    //Start barometer
    public func startBarometer() {
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter = CMAltimeter()
            let queue = OperationQueue.main
            altimeter.startRelativeAltitudeUpdates(to: queue, withHandler: { (data, error) in
                if let values = data {
                    self.altitude = values.relativeAltitude.doubleValue
                    print("altitude = \(self.altitude)")
                    print("deltaAltitude = \(self.deltaAltitude)")
                    if (abs(self.altitude)>abs(self.deltaAltitude)) {self.deltaAltitude=self.altitude}
                }
            })
        } else {
            print("This device can't measure altitude")
        }
    }
    //Stop barometer
    public func stopBarometer() {
        altimeter.stopRelativeAltitudeUpdates()
    }
    
    //Start accelerometer
    public func startAccelerometer() {
        motion.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: { data, error in
            guard error == nil else { return }
            guard let accelerometerData = data else { return }
            self.accX = accelerometerData.acceleration.x
            self.accY = accelerometerData.acceleration.y
            self.accZ = accelerometerData.acceleration.z
            self.detectRunningDown()
            self.detectRunningUp()
            self.detectRunningUpDown()
            
        })
    }
    //Stop accelerometer
    public func stopAccelerometer() {
        motion.stopAccelerometerUpdates()
    }
    
    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------
    //MOTION DETECTION
    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------
    
    //Detection running down
    //Detection limit : 2 meters
    public func detectRunningDown() {
        if ( (abs(self.accX)>2 || abs(self.accY)>2 || abs(self.accZ)>2) && self.deltaAltitude<(-2) ) {
            isRunningDownDetected=true
        }
    }
    
    //Detection running up
    public func detectRunningUp() {
        if ( (abs(self.accX)>2 || abs(self.accY)>2 || abs(self.accZ)>2) && self.deltaAltitude<2 ) {
            isRunningUpDetected=true
        }
    }
    
    //Detection running up and down
    public func detectRunningUpDown() {
        if ( isRunningUpDetected==true && abs(self.altitude)<2) {
            isRunningUpDownDetected=true
        }
    }
    
    //Detection running down and up
    public func detectRunningDownUp() {
        if ( isRunningDownDetected==true && abs(self.altitude)<(-2)) {
            isRunningDownUpDetected=true
        }
    }
    
    //Count bicep curl
    public func bicepCurlCount() {
        
        //Get the max and min of accelerometer
        accMax = max(accMax, accX, accY, accZ)
        accMax = min(accMin, accX, accY, accZ)
        
        //A bicep curl is detected, counter++
        if ( accMax>1 && accMin<(-1) ) {
            bicepCurlCounter += 1
            accMax = 0
            accMin = 0
        }
    }
    
    //Count star-jump
    public func starJumpCount() {
        
        //Get the max and min of accelerometer
        accMax = max(accMax, accX, accY, accZ)
        accMax = min(accMin, accX, accY, accZ)
        
        //A bicep curl is detected, counter++
        if ( accMax>2 && accMin<(-2) ) {
            starJumpCounter += 1
            accMax = 0
            accMin = 0
        }
    }
    
    //Detect if device is in pocket
    //
    public func detectPocket() {
        currentBrightness = UIScreen.main.brightness
        if ( currentBrightness<0.1 ) { isDeviceInPocket=true }
    }
    
    
    
}
