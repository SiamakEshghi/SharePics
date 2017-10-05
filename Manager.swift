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

//MARK: -POPUP ANIMATE
public  func showAnimateChangeAlpha(vc:UIViewController)
{
    vc.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
    vc.view.alpha = 0.0;
    UIView.animate(withDuration: 0.25, animations: {
        vc.view.alpha = 0.9
        vc.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    });
}

public  func removeAnimate(vc:UIViewController)
{
    UIView.animate(withDuration: 0.25, animations: {
        vc.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        vc.view.alpha = 0.0;
    }, completion:{(finished : Bool)  in
        if (finished)
        {
            vc.view.removeFromSuperview()
        }
    });
}



//MARK: -HIDE KEYBOARD
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
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
