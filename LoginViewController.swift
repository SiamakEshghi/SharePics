//
//  LoginViewController.swift
//  SharePics
//
//  Created by Siamak Eshghi on 2017-07-09.
//  Copyright © 2017 Joopooli. All rights reserved.
//
import UIKit
import AVFoundation
import SVProgressHUD


class LoginViewController: UIViewController,UITextFieldDelegate {
    
    //MARK: -PROPERTIES
    var isSignIn = true
    
    //MARK: -OUTLETS AND ACTIONS
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtFieldName: UITextField!
    
    @IBOutlet weak var txtFieldEmail: UITextField!
    
    @IBOutlet weak var txtFieldPass1: UITextField!
    
    @IBOutlet weak var txtFieldPass2: UITextField!
    
    var activeTextField: UITextField!
    
    @IBOutlet weak var btnSignIn: UIButton!
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    
    @IBOutlet weak var parentStackView: UIStackView!
    
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        handleSegment()
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        SVProgressHUD.show()
         handleRegisterAndSignIn()
    }
    
    @IBAction func btnForgetPass(_ sender: UIButton) {
        showForgetPassView()
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        parentStackView.distribution = .fillProportionally
        friends.removeAll()
        hiddensHandles()
        SVProgressHUD.dismiss()
        imageViewProfile.setRounded(radius: 10)
        txtFieldName.delegate = self
        txtFieldEmail.delegate = self
        txtFieldPass1.delegate = self
        txtFieldPass2.delegate = self
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 2 || textField.tag == 3 {
        scrollView.setContentOffset(CGPoint(x: 0, y:100), animated: true)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 0 {
            txtFieldEmail.becomeFirstResponder()
        }else if textField.tag == 1 {
           txtFieldPass1.becomeFirstResponder()
        }else if textField.tag == 2 {
            txtFieldPass2.becomeFirstResponder()
        }else {
            txtFieldName.becomeFirstResponder()
        }
        return true
    }

}

extension UIViewController{
    
    //Hide Keyborad when touch around
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
