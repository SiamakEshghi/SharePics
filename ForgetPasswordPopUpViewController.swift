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
        
        UsefullFunctions.showAnimate(vc: self)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
       
    }
    
   //MARK: -OUTLETS AND ACTIONS
    
    @IBOutlet weak var txtFieldEmail: UITextField!
    
    @IBAction func btnClose(_ sender: UIButton) {
        UsefullFunctions.removeAnimate(vc: self)
         self.view.removeFromSuperview()
        }

     //MARK: -RESET PASSWORD
    @IBAction func btnResetPass(_ sender: UIButton) {
        let email = txtFieldEmail.text!
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error != nil {
               UsefullFunctions.showAlert(text: "Cant send reset email!", title: "Error",vc:self)
                return
            }else{
            UsefullFunctions.showAlert(text: "Reset email is sent successfully!", title: "Success",vc: self)
            }
        }
        
    }
    
    
    
    
    
}


