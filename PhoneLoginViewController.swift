//
//  PhoneLoginViewController.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-11-28.
//  Copyright © 2017 Joopooli. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseAuth

class PhoneLoginViewController: UIViewController {

   
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        friends.removeAll()
        SVProgressHUD.dismiss()
        profileImageView.setRounded(radius: 10)
        prepareProfileImage()
    }
    override func viewWillDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        setupVideoBackground()
        AppUtility.lockOrientation(.portrait)
    }
    
    @IBAction func registerBtnTapped(_ sender: UIButton) {
        register()
    }
    
    
    
    
    

}
