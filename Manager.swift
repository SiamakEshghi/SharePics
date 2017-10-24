//
//  Manager.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-09-11.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import UIKit
import AVFoundation

var PlayerLayer: AVPlayerLayer!
var Player: AVPlayer!


//MARK: -ALERT
public  func showAlert(text:String,title:String,vc:UIViewController)  {
    let alert = UIAlertController(title: title, message: text, preferredStyle: UIAlertControllerStyle.alert)
    
    // add an action (button)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    
    // show the alert
    vc.present(alert, animated: true, completion: nil)
}




//Mark: -Lock Orientation
struct AppUtility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
}




