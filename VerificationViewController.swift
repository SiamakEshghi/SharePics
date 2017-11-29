//
//  VerifingViewController.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-11-28.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import SVProgressHUD

class VerificationViewController: UIViewController {

    //properties
    var profileImage: UIImage?
    var name: String?
    
    @IBOutlet weak var txtVerification: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)
    }
    override func viewWillAppear(_ animated: Bool) {
        setupVideoBackground()
        AppUtility.lockOrientation(.portrait)
    }

    
    @IBAction func loginTapped(_ sender: UIButton) {
       registerNewUser()
    }
    
    
    //MARK: - Register
    
    func registerNewUser()  {
        //register new user
        SVProgressHUD.show()
        let defaults = UserDefaults.standard
        
        
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVID")!, verificationCode: txtVerification.text!)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                SVProgressHUD.dismiss()
                showAlert(text: (error?.localizedDescription)!, title: "Error", vc: self)
                return
            }else{
                
                let uid = user?.uid
                let phoneNumber = user?.phoneNumber
                if  let profImage = self.profileImage{
                    saveProfileImage(profileImage: profImage , completionHandler: { (profileImageUrl) in
                        
                        saveNewUser(profileImageUrl: profileImageUrl, uid: uid!, name: self.name!, phoneNumber: phoneNumber!, completionHandler: { (isError) in
                            if isError {
                                SVProgressHUD.dismiss()
                                showAlert(text: "There is error in registeration!", title: "Error", vc: self)
                            }else{
                                self.performSegue(withIdentifier: "logged", sender: Any?.self)
                            }
                        })
                        
                    })
                }
                
            }
        }
    }
}
