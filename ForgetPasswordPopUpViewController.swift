//
//  ForgetPasswordPopUpViewController.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-07-10.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgetPasswordPopUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        showAnimate()
    }

    //MARK: -OUTLETS AND ACTIONS
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var txtFieldEmail: UITextField!
    
    @IBAction func btnClose(_ sender: UIButton) {
        self.view.removeFromSuperview()
        removeAnimate()
    }

     //MARK: -RESET PASSWORD
    @IBAction func btnResetPass(_ sender: UIButton) {
        let email = txtFieldEmail.text!
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error != nil {
               UsefullFunctions.showAlert(text: "Cant send reset email!", title: "Error",view:self)
                return
            }else{
            UsefullFunctions.showAlert(text: "Reset email is sent successfully!", title: "Success",view: self)
            }
        }
        
    }
    
    
    //MARK: -POPUP ANIMATE
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    
    }
