//
//  MotionMonitor.swift
//  Shooter
//
//  Created by student on 10/5/17.
//  Copyright © 2017 student. All rights reserved.
//

import Foundation
import CoreMotion
import CoreGraphics

class MotionMonitor{
    static let sharedMotionMonitor = MotionMonitor() // #1 single instance
    let manager = CMMotionManager() // #2 get at rotation, magentometer, altitude, etc
    var rotation: CGFloat = 0 //#3 rotation in radians
    var gravityVectorNormalized = CGVector.zero // dx,dy values between -1 to +1
    var gravityVector = CGVector.zero // #5 dx,dy values between -9.8 to +9.8
    var transform = CGAffineTransform(rotationAngle: 0) //#6 a 3x3 matrix
    
    // #7 This class is a singleton! The code below prevents someone from using the default initialization for this class
    private init(){}
    
    func startUpdates(){
        if manager.isDeviceMotionAvailable{
            print("** starting motion updates **")
            manager.deviceMotionUpdateInterval = 0.1
            manager.startDeviceMotionUpdates(to: OperationQueue.main){ // #8 trailing closure syntax
                data, error in
                guard data != nil else{ // #9 using a guard - bail out if there's no data
                    print("There was an error: \(error)")
                    return
                }
                // #10 note: self.rotation use -2 * CGFloat.pi for a landscape game
                self.rotation = CGFloat(atan2(data!.gravity.x, data!.gravity.y)) - CGFloat.pi
                // #11 a unit vector
                self.gravityVectorNormalized = CGVector(dx:CGFloat(data!.gravity.x), dy: CGFloat(data!.gravity.y))
                // #12 a gravity vector we will use in project 2 physics game
                self.gravityVector = CGVector(dx: CGFloat(data!.gravity.x) * 9.8, dy: CGFloat(data!.gravity.y) * 9.8)
                // #13 affine transfomrs are commonly used on UIView instances
                self.transform = CGAffineTransform(rotationAngle: CGFloat(self.rotation))
                
                //print("self.rotation = \(self.rotation)")
                //print("self.gravityVectorNormalized = \(self.gravityVectorNormalized)")
                // print ("self.gravityVector = \(self.gravityVector)")
                // print("self.gravityVector = \(self.gravityVector)")
            }
            
        }// end block
        
        else{
            print("Device Motion is not available! Are you on the simulator?")
        }
    }
    
    func stopUpdates(){
        print("** stopping motion updates **")
        if manager.isDeviceMotionAvailable{
            manager.stopDeviceMotionUpdates()
        }
    }
}
